#!/usr/bin/env python3
"""Construye los seis test de bloque de Técnicos de Exterior.

Genera CSV para la carga administrativa y una migración reproducible. Los
identificadores son UUID v5 estables para que los cuatro niveles del banco de
preguntas conserven siempre sus relaciones.
"""

from __future__ import annotations

import csv
import json
import uuid
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content/tecnicos-exterior-20h"
MANIFEST_PATH = CONTENT / "course-manifest.json"
QUIZZES_PATH = CONTENT / "quizzes.json"
CSV_DIR = ROOT / "tmp/tecnicos-exterior-20h/csv"
MIGRATION_PATH = (
    ROOT
    / "supabase/migrations/20261026133000_tecnicos_exterior_block_tests.sql"
)


def stable(parent: str, label: str) -> str:
    return str(uuid.uuid5(uuid.UUID(parent), label))


def sql(value: object) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    return "'" + str(value).replace("'", "''") + "'"


def write_csv(name: str, rows: list[dict[str, object]]) -> None:
    CSV_DIR.mkdir(parents=True, exist_ok=True)
    path = CSV_DIR / f"{name}.csv"
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    print(path)


manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
spec = json.loads(QUIZZES_PATH.read_text(encoding="utf-8"))

assert len(spec["blocks"]) == 6
assert spec["question_count_per_block"] == 15
assert spec["required_perfect_rounds"] == 2
assert spec["completion_mode"] == "cumulative_perfect"

version_id = manifest["version"]["id"]
lesson_ids = {lesson["ordinal"]: lesson["id"] for lesson in manifest["lessons"]}
segments_by_slide = {
    unit["slide_number"]: unit["segment_id"] for unit in manifest["units"]
}

banks: list[dict[str, object]] = []
questions: list[dict[str, object]] = []
options: list[dict[str, object]] = []
quizzes: list[dict[str, object]] = []

for block in spec["blocks"]:
    block_number = block["block"]
    bank_id = stable(version_id, f"question-bank:block:{block_number}")
    quiz_id = stable(version_id, f"quiz:block:{block_number}")
    lesson_id = lesson_ids[block["quiz_lesson_ordinal"]]
    bank_title = (
        f"Técnicos de exterior 20 h · Bloque {block_number} · "
        f"{block['title']}"
    )
    banks.append(
        {
            "id": bank_id,
            "course_version_id": version_id,
            "title": bank_title,
        }
    )

    linked_slides: set[int] = set()
    block_questions = block["questions"]
    assert len(block_questions) == spec["question_count_per_block"]

    for position, item in enumerate(block_questions, start=1):
        assert len(item["options"]) == 4
        assert 0 <= item["correct"] < 4
        question_id = stable(bank_id, f"question:{position}")
        slide = item["slide"]
        segment_id = None
        if slide is not None and slide not in linked_slides:
            segment_id = segments_by_slide[slide]
            linked_slides.add(slide)

        questions.append(
            {
                "id": question_id,
                "question_bank_id": bank_id,
                "prompt": item["prompt"],
                "type": "single_choice",
                "explanation": item["explanation"],
                "points": 1,
                "active": "true",
                "lesson_audio_segment_id": segment_id or "",
            }
        )

        for option_position, option_text in enumerate(item["options"], start=1):
            options.append(
                {
                    "id": stable(question_id, f"option:{option_position}"),
                    "question_id": question_id,
                    "position": option_position,
                    "option_text": option_text,
                    "is_correct": (
                        "true" if option_position - 1 == item["correct"] else "false"
                    ),
                }
            )

    quizzes.append(
        {
            "id": quiz_id,
            "lesson_id": lesson_id,
            "question_bank_id": bank_id,
            "title": f"Test del bloque {block_number} · 15 preguntas",
            "question_count": 15,
            "passing_percent": 100,
            "required_perfect_streak": 2,
            "randomize_questions": "true",
            "randomize_options": "true",
            "minimum_retry_seconds": 0,
            "active": "true",
            "completion_mode": "cumulative_perfect",
        }
    )

assert len(banks) == 6
assert len(questions) == 90
assert len(options) == 360
assert len(quizzes) == 6
assert all(
    sum(option["is_correct"] == "true" for option in options if option["question_id"] == question["id"])
    == 1
    for question in questions
)

write_csv("09_question_banks", banks)
write_csv("10_questions", questions)
write_csv("11_question_options", options)
write_csv("12_quizzes", quizzes)


def values(rows: list[dict[str, object]], columns: list[str]) -> str:
    return ",\n".join(
        "  (" + ", ".join(sql(row[column] or None) for column in columns) + ")"
        for row in rows
    )


bank_columns = ["id", "course_version_id", "title"]
question_columns = [
    "id",
    "question_bank_id",
    "prompt",
    "type",
    "explanation",
    "points",
    "active",
    "lesson_audio_segment_id",
]
option_columns = ["id", "question_id", "position", "option_text", "is_correct"]
quiz_columns = [
    "id",
    "lesson_id",
    "question_bank_id",
    "title",
    "question_count",
    "passing_percent",
    "required_perfect_streak",
    "randomize_questions",
    "randomize_options",
    "minimum_retry_seconds",
    "active",
    "completion_mode",
]

bank_ids = ", ".join(sql(row["id"]) for row in banks)

migration = f"""-- Seis evaluaciones de bloque para Técnicos titulados de exterior (20 h).
-- Cada test exige dos rondas perfectas acumuladas antes de desbloquear la
-- siguiente lección, frente a las tres habituales del resto del campus.

begin;

update public.course_versions
set required_perfect_streak = 2, updated_at = now()
where id = {sql(version_id)}
  and status = 'draft';

insert into public.question_banks ({', '.join(bank_columns)})
values
{values(banks, bank_columns)}
on conflict (id) do update set
  course_version_id = excluded.course_version_id,
  title = excluded.title,
  updated_at = now();

insert into public.questions ({', '.join(question_columns)})
values
{values(questions, question_columns)}
on conflict (id) do update set
  question_bank_id = excluded.question_bank_id,
  prompt = excluded.prompt,
  type = excluded.type,
  explanation = excluded.explanation,
  points = excluded.points,
  active = excluded.active,
  lesson_audio_segment_id = excluded.lesson_audio_segment_id,
  updated_at = now();

insert into public.question_options ({', '.join(option_columns)})
values
{values(options, option_columns)}
on conflict (id) do update set
  question_id = excluded.question_id,
  position = excluded.position,
  option_text = excluded.option_text,
  is_correct = excluded.is_correct,
  updated_at = now();

insert into public.quizzes ({', '.join(quiz_columns)})
values
{values(quizzes, quiz_columns)}
on conflict (lesson_id) do update set
  question_bank_id = excluded.question_bank_id,
  title = excluded.title,
  question_count = excluded.question_count,
  passing_percent = excluded.passing_percent,
  required_perfect_streak = excluded.required_perfect_streak,
  randomize_questions = excluded.randomize_questions,
  randomize_options = excluded.randomize_options,
  minimum_retry_seconds = excluded.minimum_retry_seconds,
  active = excluded.active,
  completion_mode = excluded.completion_mode,
  updated_at = now();

do $$
declare
  v_banks integer;
  v_questions integer;
  v_options integer;
  v_quizzes integer;
begin
  select count(*) into v_banks
  from public.question_banks where id in ({bank_ids});

  select count(*) into v_questions
  from public.questions where question_bank_id in ({bank_ids});

  select count(*) into v_options
  from public.question_options qo
  join public.questions q on q.id = qo.question_id
  where q.question_bank_id in ({bank_ids});

  select count(*) into v_quizzes
  from public.quizzes q
  where q.question_bank_id in ({bank_ids})
    and q.question_count = 15
    and q.passing_percent = 100
    and q.required_perfect_streak = 2
    and q.completion_mode = 'cumulative_perfect'
    and q.active;

  if v_banks <> 6 or v_questions <> 90 or v_options <> 360 or v_quizzes <> 6 then
    raise exception 'Evaluaciones incompletas: bancos %, preguntas %, opciones %, tests %',
      v_banks, v_questions, v_options, v_quizzes;
  end if;

  if exists (
    select q.id
    from public.questions q
    left join lateral (
      select count(*) as option_count,
             count(*) filter (where qo.is_correct) as correct_count
      from public.question_options qo
      where qo.question_id = q.id
    ) checked on true
    where q.question_bank_id in ({bank_ids})
      and (checked.option_count <> 4 or checked.correct_count <> 1)
  ) then
    raise exception 'Cada pregunta debe tener cuatro opciones y una sola correcta';
  end if;
end $$;

commit;
"""

MIGRATION_PATH.write_text(migration, encoding="utf-8")
print(MIGRATION_PATH)
