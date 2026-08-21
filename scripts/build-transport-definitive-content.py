#!/usr/bin/env python3
"""Build the definitive transport-course slides, manifest and SQL migration.

The source PDFs/TXT files stay outside git. Generated JPEGs and the manifest are
written to tmp/transport-course-assets. The generated SQL is deterministic and
updates the existing 5 h and 20 h versions without replacing audio segments,
enrollments or progress rows.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
from pathlib import Path

import pymupdf
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
DOWNLOADS = Path.home() / "Downloads"
OUTPUT_DIR = Path(os.environ.get("TRANSPORT_ASSETS_DIR", ROOT / "tmp" / "transport-course-assets"))
MIGRATION_PATH = Path(
    os.environ.get(
        "TRANSPORT_MIGRATION_PATH",
        ROOT / "supabase" / "migrations" / "20260821160000_transport_courses_definitive_content.sql",
    )
)
RELEASE = "transport-definitive-20260821"
COURSE_SLUG = "operador-maquinaria-transporte-camion-volquete"

SOURCES = {
    20: {
        "slides": Path(
            os.environ.get(
                "TRANSPORT_20H_SLIDES_PDF",
                DOWNLOADS / "Curso_5_Maquinaria_Transporte_20h_Diapositivas_InminerCampus_COMPLETAS.pdf",
            )
        ),
        "notes": Path(
            os.environ.get(
                "TRANSPORT_20H_NOTES_PDF",
                DOWNLOADS / "Curso_5_Maquinaria_Transporte_20h_Explicaciones_Detalladas_INMINER.pdf",
            )
        ),
        "questions": Path(
            os.environ.get(
                "TRANSPORT_20H_QUESTIONS_TXT",
                DOWNLOADS / "Test_Transporte_20h_75_preguntas.txt",
            )
        ),
        "slide_pages": lambda block, part: 2 * ((block - 1) * 10 + part),
        "expected_slide_pages": 100,
        "source_label": "Presentación definitiva · Transporte · Formación inicial 20 h",
        "notes_label": "Explicaciones detalladas · Transporte · Formación inicial 20 h",
    },
    5: {
        "slides": Path(
            os.environ.get(
                "TRANSPORT_5H_SLIDES_PDF",
                DOWNLOADS / "Curso_2_Transporte_5h__INMINER.pdf",
            )
        ),
        "notes": Path(
            os.environ.get(
                "TRANSPORT_5H_NOTES_PDF",
                DOWNLOADS / "Curso_2_Transporte_5h_Explicaciones_Detalladas_Reciclaje_INMINER.pdf",
            )
        ),
        "questions": Path(
            os.environ.get(
                "TRANSPORT_5H_QUESTIONS_TXT",
                DOWNLOADS / "Test_Transporte_Reciclaje_5h_75_preguntas.txt",
            )
        ),
        "slide_pages": lambda block, part: 1 + 11 * (block - 1) + part,
        "expected_slide_pages": 55,
        "source_label": "Presentación definitiva · Transporte · Reciclaje 5 h",
        "notes_label": "Explicaciones detalladas · Transporte · Reciclaje 5 h",
    },
}

SECTION_NAMES = [
    "OBJETIVO",
    "Explicación detallada",
    "APLICACIÓN EN LA EXPLOTACIÓN",
    "ERRORES CRÍTICOS QUE DEBEN EVITARSE",
    "COMPROBACIÓN ANTES DE CONTINUAR",
    "IDEA CLAVE",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def sql(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def join_wrapped(lines: list[str]) -> str:
    return " ".join(line.strip() for line in lines if line.strip()).strip()


def parse_note_page(page: pymupdf.Page, expected_part: str) -> dict[str, object]:
    lines = [line.strip() for line in page.get_text("text").splitlines() if line.strip()]
    try:
        part_index = next(i for i, line in enumerate(lines) if line == f"PARTE {expected_part}")
        objective_index = lines.index("OBJETIVO", part_index + 1)
    except (StopIteration, ValueError) as error:
        raise ValueError(f"No se encontró PARTE {expected_part} con OBJETIVO en la página {page.number + 1}") from error

    title = join_wrapped(lines[part_index + 1 : objective_index])
    boundaries: list[tuple[str, int]] = []
    for section in SECTION_NAMES:
        try:
            boundaries.append((section, lines.index(section, objective_index)))
        except ValueError as error:
            raise ValueError(f"Falta la sección {section} en PARTE {expected_part}") from error
    boundaries.sort(key=lambda item: item[1])

    sections: dict[str, str] = {}
    bullets: dict[str, list[str]] = {}
    for idx, (name, start) in enumerate(boundaries):
        end = boundaries[idx + 1][1] if idx + 1 < len(boundaries) else len(lines)
        body_lines = lines[start + 1 : end]
        if name == "IDEA CLAVE":
            body_lines = body_lines[: next((i for i, line in enumerate(body_lines) if line.startswith("Trazabilidad:")), len(body_lines))]
        items: list[str] = []
        prose: list[str] = []
        current_item: list[str] | None = None
        for line in body_lines:
            if line.startswith("•"):
                if current_item:
                    items.append(join_wrapped(current_item))
                current_item = [line[1:].strip()]
            elif current_item is not None:
                current_item.append(line)
            else:
                prose.append(line)
        if current_item:
            items.append(join_wrapped(current_item))
        sections[name] = join_wrapped(prose)
        bullets[name] = items

    rendered_sections: list[str] = []
    for name in SECTION_NAMES:
        heading = "EXPLICACIÓN DETALLADA" if name == "Explicación detallada" else name
        content_parts: list[str] = []
        if sections[name]:
            content_parts.append(sections[name])
        if bullets[name]:
            content_parts.extend(f"• {item}" for item in bullets[name])
        rendered_sections.append(f"{heading}\n\n" + "\n".join(content_parts))

    return {
        "title": title,
        "summary": "\n\n".join(rendered_sections).strip(),
        "key_points": bullets["COMPROBACIÓN ANTES DE CONTINUAR"],
        "stop_criterion": sections["IDEA CLAVE"],
    }


def parse_questions(path: Path) -> list[dict[str, object]]:
    lines = path.read_text(encoding="utf-8-sig").splitlines()
    result: list[dict[str, object]] = []
    block = 0
    current: dict[str, object] | None = None
    active_field: tuple[str, str | None] | None = None

    def append_continuation(line: str) -> None:
        nonlocal current
        if current is None or active_field is None:
            return
        field, option = active_field
        if field == "prompt":
            current["prompt"] = f"{current['prompt']} {line}".strip()
        elif field == "option" and option:
            options = current["options"]
            assert isinstance(options, dict)
            options[option] = f"{options[option]} {line}".strip()

    for raw in lines:
        line = raw.strip()
        if not line:
            continue
        if line.startswith("BLOQUE "):
            block += 1
            current = None
            active_field = None
            continue
        question_match = re.match(r"^(\d+)\.\s+(.+)$", line)
        if question_match and block:
            current = {
                "block": block,
                "source_number": int(question_match.group(1)),
                "position": 1 + sum(1 for item in result if item["block"] == block),
                "prompt": question_match.group(2).strip(),
                "options": {},
                "correct": None,
                "part": None,
            }
            result.append(current)
            active_field = ("prompt", None)
            continue
        option_match = re.match(r"^([ABCD])\.\s+(.+)$", line)
        if option_match and current:
            options = current["options"]
            assert isinstance(options, dict)
            options[option_match.group(1)] = option_match.group(2).strip()
            active_field = ("option", option_match.group(1))
            continue
        correct_match = re.match(r"^Respuesta correcta:\s*([ABCD])$", line)
        if correct_match and current:
            current["correct"] = correct_match.group(1)
            active_field = None
            continue
        part_match = re.match(
            r"^Parte:\s*((?:[1-5]\.10|[1-5]\.[1-9])(?:-(?:[1-5]\.10|[1-5]\.[1-9]))?)$",
            line,
        )
        if part_match and current:
            current["part"] = part_match.group(1)
            current["primary_part"] = part_match.group(1).split("-", 1)[0]
            active_field = None
            continue
        append_continuation(line)

    if block != 5 or len(result) != 75:
        raise ValueError(f"{path.name}: se esperaban 5 bloques/75 preguntas y se obtuvieron {block}/{len(result)}")
    for expected_block in range(1, 6):
        questions = [item for item in result if item["block"] == expected_block]
        if len(questions) != 15:
            raise ValueError(f"{path.name}: el bloque {expected_block} no tiene 15 preguntas")
        for item in questions:
            options = item["options"]
            if not isinstance(options, dict) or list(options) != ["A", "B", "C", "D"]:
                raise ValueError(f"{path.name}: opciones inválidas en la pregunta {item['source_number']}")
            if item["correct"] not in options or not item["part"]:
                raise ValueError(f"{path.name}: respuesta/parte inválida en la pregunta {item['source_number']}")
            part_block = int(str(item["primary_part"]).split(".")[0])
            part_end_block = int(str(item["part"]).split("-", 1)[-1].split(".")[0])
            if part_block != expected_block:
                raise ValueError(f"{path.name}: la pregunta {item['source_number']} apunta a otro bloque")
            if part_end_block != expected_block:
                raise ValueError(f"{path.name}: el rango de la pregunta {item['source_number']} cruza bloques")
    return result


def render_slide(page: pymupdf.Page, destination: Path) -> None:
    scale = 1600 / page.rect.width
    pixmap = page.get_pixmap(matrix=pymupdf.Matrix(scale, scale), alpha=False)
    image = Image.frombytes("RGB", [pixmap.width, pixmap.height], pixmap.samples)
    if image.size != (1600, 900):
        image.thumbnail((1600, 900), Image.Resampling.LANCZOS)
        canvas = Image.new("RGB", (1600, 900), "white")
        canvas.paste(image, ((1600 - image.width) // 2, (900 - image.height) // 2))
        image = canvas
    destination.parent.mkdir(parents=True, exist_ok=True)
    image.save(destination, format="JPEG", quality=91, optimize=True, progressive=True)


def validate_sources() -> None:
    for duration, config in SOURCES.items():
        for kind in ("slides", "notes", "questions"):
            path = config[kind]
            assert isinstance(path, Path)
            if not path.is_file():
                raise FileNotFoundError(f"Falta la fuente {duration} h ({kind}): {path}")


def build() -> tuple[list[dict[str, object]], list[dict[str, object]], dict[str, object]]:
    validate_sources()
    content: list[dict[str, object]] = []
    questions: list[dict[str, object]] = []
    manifest: dict[str, object] = {"course_slug": COURSE_SLUG, "release": RELEASE, "versions": {}}

    for duration, config in SOURCES.items():
        slides_path = config["slides"]
        notes_path = config["notes"]
        questions_path = config["questions"]
        assert isinstance(slides_path, Path) and isinstance(notes_path, Path) and isinstance(questions_path, Path)
        slide_doc = pymupdf.open(slides_path)
        note_doc = pymupdf.open(notes_path)
        if len(slide_doc) != config["expected_slide_pages"]:
            raise ValueError(f"{slides_path.name}: páginas inesperadas ({len(slide_doc)})")
        if len(note_doc) != 65:
            raise ValueError(f"{notes_path.name}: se esperaban 65 páginas y hay {len(note_doc)}")

        version_manifest: dict[str, object] = {
            "slides_pdf": {"path": str(slides_path), "pages": len(slide_doc), "sha256": sha256(slides_path)},
            "notes_pdf": {"path": str(notes_path), "pages": len(note_doc), "sha256": sha256(notes_path)},
            "questions_txt": {"path": str(questions_path), "sha256": sha256(questions_path)},
            "slides": [],
        }
        for block in range(1, 6):
            for part in range(1, 11):
                label = f"{block}.{part}"
                note_page_number = 5 + 12 * (block - 1) + part
                slide_page_number = config["slide_pages"](block, part)
                note = parse_note_page(note_doc[note_page_number - 1], label)
                relative_slide = Path(f"{duration}h") / "slides" / f"block-{block}" / f"part-{block}-{part:02d}.jpg"
                output_slide = OUTPUT_DIR / relative_slide
                render_slide(slide_doc[slide_page_number - 1], output_slide)
                slide_hash = sha256(output_slide)
                content.append(
                    {
                        "duration": duration,
                        "block": block,
                        "part": part,
                        "title": note["title"],
                        "note_page": note_page_number,
                        "slide_page": slide_page_number,
                        "slide_relative_path": relative_slide.as_posix(),
                        "summary": note["summary"],
                        "key_points": note["key_points"],
                        "stop_criterion": note["stop_criterion"],
                        "slide_source_label": config["source_label"],
                        "notes_source_label": config["notes_label"],
                    }
                )
                version_manifest["slides"].append(
                    {"part": label, "source_page": slide_page_number, "path": relative_slide.as_posix(), "sha256": slide_hash}
                )
        parsed_questions = parse_questions(questions_path)
        for item in parsed_questions:
            item["duration"] = duration
            questions.append(item)
        version_manifest["content_count"] = 50
        version_manifest["question_count"] = len(parsed_questions)
        manifest["versions"][str(duration)] = version_manifest
        slide_doc.close()
        note_doc.close()

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUTPUT_DIR / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return content, questions, manifest


def array_sql(values: list[str]) -> str:
    if not values:
        return "ARRAY[]::text[]"
    return "ARRAY[" + ", ".join(sql(value) for value in values) + "]::text[]"


def generate_migration(content: list[dict[str, object]], questions: list[dict[str, object]]) -> str:
    module_titles: dict[int, list[str]] = {}
    for duration in (5, 20):
        module_titles[duration] = []
        for block in range(1, 6):
            divider_page = 5 + 12 * (block - 1)
            doc = pymupdf.open(SOURCES[duration]["notes"])
            lines = [line.strip() for line in doc[divider_page - 1].get_text("text").splitlines() if line.strip()]
            doc.close()
            title_lines = []
            for line in lines:
                if line.startswith("Asignación didáctica") or line.startswith("Diez partes") or line.startswith("Referencia"):
                    break
                if line.startswith("INMÍNERCAMPUS") or line.isdigit() or line.startswith("BLOQUE "):
                    continue
                title_lines.append(line)
            module_titles[duration].append(join_wrapped(title_lines))

    content_rows = []
    for item in content:
        content_rows.append(
            "  (" + ", ".join(
                [
                    str(item["duration"]), str(item["block"]), str(item["part"]), sql(str(item["title"])),
                    str(item["slide_page"]), str(item["note_page"]), sql(str(item["summary"])),
                    array_sql(item["key_points"]), sql(str(item["stop_criterion"])),
                    sql(str(item["slide_source_label"])), sql(str(item["notes_source_label"])),
                ]
            ) + ")"
        )

    question_rows = []
    for item in questions:
        options = item["options"]
        assert isinstance(options, dict)
        part_block, part_position = map(int, str(item["primary_part"]).split("."))
        question_rows.append(
            "  (" + ", ".join(
                [
                    str(item["duration"]), str(item["block"]), str(item["position"]), sql(str(item["prompt"])),
                    sql(options["A"]), sql(options["B"]), sql(options["C"]), sql(options["D"]),
                    str("ABCD".index(str(item["correct"])) + 1), str(part_block), str(part_position), sql(str(item["part"])),
                ]
            ) + ")"
        )

    module_rows = []
    for duration in (5, 20):
        for block, title in enumerate(module_titles[duration], 1):
            module_rows.append(f"  ({duration}, {block}, {sql(title)})")

    return f"""-- Definitive integration of both existing transport courses (5 h recycling and
-- 20 h initial training). Generated by scripts/build-transport-definitive-content.py.
-- Keeps course/version/lesson/segment/enrollment/progress IDs and all audio paths.

begin;

create temporary table _transport_targets on commit drop as
select cv.id as version_id, cv.duration_hours
from public.course_versions cv
join public.courses c on c.id = cv.course_id
where c.slug = {sql(COURSE_SLUG)}
  and cv.duration_hours in (5, 20);

do $$
declare
  v_versions integer;
  v_segments integer;
  v_audio_objects integer;
  v_quizzes integer;
  v_questions integer;
  v_options integer;
  v_correct integer;
begin
  select count(*) into v_versions from _transport_targets;
  if v_versions <> 2 then raise exception 'Transport integration: expected 2 target versions, found %', v_versions; end if;

  select count(*) into v_segments
  from _transport_targets t
  join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
  join public.lessons l on l.module_id=cm.id
  join public.lesson_audio_segments s on s.lesson_id=l.id and s.position between 1 and 10
  where s.audio_storage_path is not null;
  if v_segments <> 100 then raise exception 'Transport integration: expected 100 mapped audio segments, found %', v_segments; end if;

  select count(*) into v_audio_objects
  from _transport_targets t
  join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
  join public.lessons l on l.module_id=cm.id
  join public.lesson_audio_segments s on s.lesson_id=l.id and s.position between 1 and 10
  join storage.objects o on o.bucket_id='course-materials' and o.name=s.audio_storage_path;
  if v_audio_objects <> 100 then raise exception 'Transport integration: expected 100 stored audio objects, found %', v_audio_objects; end if;

  select count(*) into v_quizzes
  from _transport_targets t
  join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
  join public.lessons l on l.module_id=cm.id
  join public.quizzes qz on qz.lesson_id=l.id and qz.active;
  if v_quizzes <> 10 then raise exception 'Transport integration: expected 10 active block quizzes, found %', v_quizzes; end if;

  select count(distinct q.id), count(qo.id), count(qo.id) filter (where qo.is_correct)
  into v_questions, v_options, v_correct
  from _transport_targets t
  join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
  join public.lessons l on l.module_id=cm.id
  join public.quizzes qz on qz.lesson_id=l.id and qz.active
  join public.questions q on q.question_bank_id=qz.question_bank_id and q.active
  join public.question_options qo on qo.question_id=q.id;
  if v_questions <> 150 or v_options <> 600 or v_correct <> 150 then
    raise exception 'Transport integration: expected 150 questions/600 options/150 correct; found %/%/%', v_questions, v_options, v_correct;
  end if;
end $$;

create temporary table _transport_modules (
  duration_hours integer not null,
  block_position integer not null,
  title text not null,
  primary key (duration_hours, block_position)
) on commit drop;
insert into _transport_modules values
{',\n'.join(module_rows)};

create temporary table _transport_content (
  duration_hours integer not null,
  block_position integer not null,
  part_position integer not null,
  title text not null,
  slide_source_page integer not null,
  notes_source_page integer not null,
  note_summary text not null,
  key_points text[] not null,
  stop_criterion text not null,
  slide_source_label text not null,
  notes_source_label text not null,
  primary key (duration_hours, block_position, part_position)
) on commit drop;
insert into _transport_content values
{',\n'.join(content_rows)};

create temporary table _transport_question_source (
  duration_hours integer not null,
  block_position integer not null,
  question_position integer not null,
  prompt text not null,
  option_a text not null,
  option_b text not null,
  option_c text not null,
  option_d text not null,
  correct_position integer not null check (correct_position between 1 and 4),
  part_block integer not null,
  part_position integer not null,
  part_label text not null,
  primary key (duration_hours, block_position, question_position)
) on commit drop;
insert into _transport_question_source values
{',\n'.join(question_rows)};

do $$
begin
  if (select count(*) from _transport_content) <> 100 then raise exception 'Transport integration: generated content count is not 100'; end if;
  if (select count(*) from _transport_question_source) <> 150 then raise exception 'Transport integration: generated question count is not 150'; end if;
end $$;

update public.course_versions cv
set accreditation_label = 'ITC 02.1.02 · ET 2000-1-08',
    accreditation_reference = 'ITC 02.1.02 · ET 2000-1-08',
    renewal_interval_months = case when cv.duration_hours=5 then 24 else cv.renewal_interval_months end,
    updated_at = now()
from _transport_targets t
where cv.id=t.version_id;

update public.course_modules cm
set title=m.title, description=m.title, updated_at=now()
from _transport_targets t
join _transport_modules m on m.duration_hours=t.duration_hours
where cm.course_version_id=t.version_id and cm.position=m.block_position;

update public.lessons l
set title=m.title,
    summary=case when t.duration_hours=5 then 'Reciclaje · 10 partes guiadas por audio' else 'Formación inicial · 10 partes guiadas por audio' end,
    duration_minutes=case when t.duration_hours=5 then 60 else 240 end,
    content_mode='audio', active=true, sequential_required=true, updated_at=now()
from _transport_targets t
join _transport_modules m on m.duration_hours=t.duration_hours
join public.course_modules cm on cm.course_version_id=t.version_id and cm.position=m.block_position
where l.module_id=cm.id;

create temporary table _transport_segments on commit drop as
select t.duration_hours, cm.position block_position, s.position part_position, s.id segment_id
from _transport_targets t
join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
join public.lessons l on l.module_id=cm.id
join public.lesson_audio_segments s on s.lesson_id=l.id and s.position between 1 and 10;

update public.lesson_audio_segments s
set title=c.title, published=true, updated_at=now()
from _transport_segments map
join _transport_content c using (duration_hours, block_position, part_position)
where s.id=map.segment_id;

with ranked as (
  select sl.id, row_number() over (partition by sl.segment_id order by sl.position, sl.created_at, sl.id) rn
  from public.lesson_segment_slides sl join _transport_segments map on map.segment_id=sl.segment_id
)
delete from public.lesson_segment_slides sl using ranked r where sl.id=r.id and r.rn>1;

update public.lesson_segment_slides sl
set position=1, title=c.title, body=c.note_summary,
    image_storage_path=t.version_id::text || '/slides/{RELEASE}/block-' || c.block_position || '/part-' || c.block_position || '-' || lpad(c.part_position::text,2,'0') || '.jpg',
    image_external_url=null, source_label=c.slide_source_label,
    source_page=c.slide_source_page::text,
    alt_text='Parte ' || c.block_position || '.' || c.part_position || ' · ' || c.title,
    updated_at=now()
from _transport_segments map
join _transport_content c using (duration_hours, block_position, part_position)
join _transport_targets t on t.duration_hours=map.duration_hours
where sl.segment_id=map.segment_id;

insert into public.lesson_segment_slides
  (segment_id, position, title, body, image_storage_path, source_label, source_page, alt_text)
select map.segment_id, 1, c.title, c.note_summary,
       t.version_id::text || '/slides/{RELEASE}/block-' || c.block_position || '/part-' || c.block_position || '-' || lpad(c.part_position::text,2,'0') || '.jpg',
       c.slide_source_label, c.slide_source_page::text,
       'Parte ' || c.block_position || '.' || c.part_position || ' · ' || c.title
from _transport_segments map
join _transport_content c using (duration_hours, block_position, part_position)
join _transport_targets t on t.duration_hours=map.duration_hours
where not exists (select 1 from public.lesson_segment_slides sl where sl.segment_id=map.segment_id);

update public.lesson_segment_notes n
set summary=c.note_summary, key_points=c.key_points, stop_criterion=c.stop_criterion,
    source_label=c.notes_source_label, source_pages=c.notes_source_page::text,
    approved=true, updated_at=now()
from _transport_segments map
join _transport_content c using (duration_hours, block_position, part_position)
where n.segment_id=map.segment_id;

insert into public.lesson_segment_notes
  (segment_id, summary, key_points, stop_criterion, source_label, source_pages, approved)
select map.segment_id, c.note_summary, c.key_points, c.stop_criterion,
       c.notes_source_label, c.notes_source_page::text, true
from _transport_segments map
join _transport_content c using (duration_hours, block_position, part_position)
where not exists (select 1 from public.lesson_segment_notes n where n.segment_id=map.segment_id);

insert into public.lesson_resources
  (lesson_id, kind, title, storage_path, mime_type, downloadable, required, position)
select l.id, resource.kind::public.resource_kind,
       case
         when resource.kind='presentation' and t.duration_hours=5 then 'Ver presentación completa · Reciclaje 5 h'
         when resource.kind='presentation' then 'Ver presentación completa · Formación inicial 20 h'
         when t.duration_hours=5 then 'Ver explicaciones completas · Reciclaje 5 h'
         else 'Ver explicaciones completas · Formación inicial 20 h'
       end,
       t.version_id::text || '/resources/transport-' || t.duration_hours || 'h-' || resource.file_suffix || '.pdf',
       'application/pdf', true, false, resource.position
from _transport_targets t
join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
join public.lessons l on l.module_id=cm.id
cross join (values
  ('presentation', 'presentacion-completa', 1),
  ('pdf', 'explicaciones-completas', 2)
) as resource(kind, file_suffix, position)
where not exists (
  select 1 from public.lesson_resources r
  where r.lesson_id=l.id
    and r.storage_path=t.version_id::text || '/resources/transport-' || t.duration_hours || 'h-' || resource.file_suffix || '.pdf'
);

create temporary table _transport_question_map on commit drop as
select t.duration_hours, cm.position block_position, qz.id quiz_id, qb.id bank_id,
       q.id question_id,
       row_number() over (partition by t.duration_hours, cm.position order by q.created_at, q.id)::integer question_position
from _transport_targets t
join public.course_modules cm on cm.course_version_id=t.version_id and cm.position between 1 and 5
join public.lessons l on l.module_id=cm.id
join public.quizzes qz on qz.lesson_id=l.id and qz.active
join public.question_banks qb on qb.id=qz.question_bank_id
join public.questions q on q.question_bank_id=qb.id and q.active;

update public.question_banks qb
set title='Test oficial · Transporte · ' || src.duration_hours || ' h · Bloque ' || src.block_position,
    updated_at=now()
from (select distinct duration_hours,block_position,bank_id from _transport_question_map) src
where qb.id=src.bank_id;

update public.quizzes qz
set title='Test del bloque ' || map.block_position || ' · 15 preguntas', question_count=15,
    passing_percent=100, required_perfect_streak=3, active=true,
    completion_mode='cumulative_perfect', updated_at=now()
from (select distinct block_position,quiz_id from _transport_question_map) map
where qz.id=map.quiz_id;

-- Release the existing segment associations before permuting them. The unique
-- index is immediate, so a direct swap can otherwise collide mid-statement.
update public.questions q
set lesson_audio_segment_id=null, updated_at=now()
from _transport_question_map map
where q.id=map.question_id;

update public.questions q
set prompt=src.prompt, type='single_choice', points=1, active=true,
    explanation='Fuente: test oficial aportado · Parte ' || src.part_label,
    lesson_audio_segment_id=case when src.segment_link_rank=1 then seg.segment_id else null end,
    updated_at=now()
from _transport_question_map map
join (
  select source.*,
         row_number() over (
           partition by duration_hours,block_position,part_block,part_position
           order by question_position
         ) as segment_link_rank
  from _transport_question_source source
) src using (duration_hours,block_position,question_position)
join _transport_segments seg on seg.duration_hours=src.duration_hours and seg.block_position=src.part_block and seg.part_position=src.part_position
where q.id=map.question_id;

update public.question_options qo
set option_text=case qo.position when 1 then src.option_a when 2 then src.option_b when 3 then src.option_c when 4 then src.option_d end,
    is_correct=(qo.position=src.correct_position), updated_at=now()
from _transport_question_map map
join _transport_question_source src using (duration_hours,block_position,question_position)
where qo.question_id=map.question_id and qo.position between 1 and 4;

-- Preserve the legacy sixth module and all historic rows, but remove it from the
-- active five-block learning path and from assessment selection.
update public.lessons l set active=false, updated_at=now()
from _transport_targets t join public.course_modules cm on cm.course_version_id=t.version_id and cm.position>5
where l.module_id=cm.id;

update public.lesson_audio_segments s set published=false, updated_at=now()
from public.lessons l
join public.course_modules cm on cm.id=l.module_id
join _transport_targets t on t.version_id=cm.course_version_id
where s.lesson_id=l.id and cm.position>5;

update public.quizzes qz set active=false, updated_at=now()
from public.lessons l
join public.course_modules cm on cm.id=l.module_id
join _transport_targets t on t.version_id=cm.course_version_id
where qz.lesson_id=l.id and cm.position>5;

update public.questions q set active=false, updated_at=now()
from public.quizzes qz
join public.lessons l on l.id=qz.lesson_id
join public.course_modules cm on cm.id=l.module_id
join _transport_targets t on t.version_id=cm.course_version_id
where q.question_bank_id=qz.question_bank_id and cm.position>5;

do $$
declare
  v_segments integer; v_slides integer; v_notes integer; v_questions integer;
  v_options integer; v_correct integer; v_active_quizzes integer; v_active_lessons integer;
begin
  select count(*) into v_segments from _transport_segments;
  select count(*) into v_slides from public.lesson_segment_slides sl join _transport_segments s on s.segment_id=sl.segment_id;
  select count(*) into v_notes from public.lesson_segment_notes n join _transport_segments s on s.segment_id=n.segment_id where n.approved and length(n.summary)>500;
  select count(distinct q.id), count(qo.id), count(qo.id) filter (where qo.is_correct)
  into v_questions,v_options,v_correct
  from _transport_question_map map
  join public.questions q on q.id=map.question_id and q.active
  join public.question_options qo on qo.question_id=q.id;
  select count(distinct qz.id) into v_active_quizzes from _transport_question_map map join public.quizzes qz on qz.id=map.quiz_id and qz.active;
  select count(*) into v_active_lessons
  from _transport_targets t join public.course_modules cm on cm.course_version_id=t.version_id
  join public.lessons l on l.module_id=cm.id and l.active;
  if v_segments<>100 or v_slides<>100 or v_notes<>100 then
    raise exception 'Transport integration final content mismatch: segments/slides/notes %/%/%',v_segments,v_slides,v_notes;
  end if;
  if v_questions<>150 or v_options<>600 or v_correct<>150 then
    raise exception 'Transport integration final assessment mismatch: questions/options/correct %/%/%',v_questions,v_options,v_correct;
  end if;
  if v_active_quizzes<>10 then raise exception 'Transport integration: expected 10 active quizzes, found %',v_active_quizzes; end if;
  if v_active_lessons<>10 then raise exception 'Transport integration: expected 10 active lessons, found %',v_active_lessons; end if;
end $$;

commit;
"""


def main() -> None:
    content, questions, _manifest = build()
    migration = generate_migration(content, questions)
    MIGRATION_PATH.parent.mkdir(parents=True, exist_ok=True)
    MIGRATION_PATH.write_text(migration, encoding="utf-8", newline="\n")
    print(f"Generated {len(content)} parts, {len(questions)} questions and 100 JPEGs.")
    print(f"Manifest: {OUTPUT_DIR / 'manifest.json'}")
    print(f"Migration: {MIGRATION_PATH}")


if __name__ == "__main__":
    main()
