#!/usr/bin/env python3
"""Construye el paquete importable del curso de técnicos de exterior (20 h).

La salida contiene 92 diapositivas, 92 audios, los dos PDF maestros, un
manifiesto verificable y una migración idempotente que deja el curso en
borrador. Los objetos de Storage usan como primer prefijo el UUID de la
versión, de acuerdo con las políticas privadas de InmínerCampus.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import tempfile
import uuid
import zipfile
from pathlib import Path

from PIL import Image
from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[1]
AUTHORING_PATH = ROOT / "scripts/tecnicos_exterior_authoring.py"
CONTENT_DIR = ROOT / "content/tecnicos-exterior-20h"
DEFAULT_OUTPUT = ROOT / "tmp/tecnicos-exterior-20h"
MIGRATION_PATH = (
    ROOT
    / "supabase/migrations/20261026120000_tecnicos_exterior_20h_draft.sql"
)
MANIFEST_PATH = CONTENT_DIR / "course-manifest.json"

COURSE_SLUG = "tecnicos-titulados-actividades-extractivas-exterior"
COURSE_TITLE = "Técnicos titulados en actividades extractivas de exterior"
RELEASE = "v1-2026-10"
BUCKET = "course-materials"
NAMESPACE = uuid.UUID("9d43b18a-ecac-4d86-a360-59ed6cb31e22")

MODULES = [
    (1, 0, "Bloque 0 · El técnico titulado y el sistema preventivo minero", 0),
    (2, 1, "Bloque 1 · Definición de los trabajos", 60),
    (3, 2, "Bloque 2 · Técnicas preventivas y de protección", 420),
    (4, 3, "Bloque 3 · Equipos de trabajo, EPI y medios auxiliares", 420),
    (5, 4, "Bloque 4 · Control y vigilancia del lugar de trabajo", 120),
    (6, 5, "Bloque 5 · Interferencias con otras actividades", 120),
    (7, 6, "Bloque 6 · Normativa y legislación", 60),
]

LESSONS = [
    (1, 1, 1, "Marco de partida: anticipar, supervisar y poder parar", 1, 10, 0),
    (2, 2, 1, "Definición de los trabajos y de sus interacciones", 11, 20, 60),
    (3, 3, 1, "Evaluación, estabilidad, agua y circulación", 21, 30, 191),
    (4, 3, 2, "Voladuras, consignación y agentes físicos", 31, 40, 191),
    (5, 3, 3, "Comprobación y resolución de técnicas preventivas", 41, 42, 38),
    (6, 4, 1, "Selección, adecuación e inspección de equipos", 43, 52, 210),
    (7, 4, 2, "Mantenimiento, EPI y medios auxiliares", 53, 62, 210),
    (8, 5, 1, "Control, vigilancia, desviaciones y reapertura", 63, 72, 120),
    (9, 6, 1, "Coordinación de actividades e interferencias", 73, 82, 120),
    (10, 7, 1, "Marco normativo y actualización documental", 83, 92, 60),
]


def stable_uuid(label: str) -> str:
    return str(uuid.uuid5(NAMESPACE, label))


def load_authoring():
    spec = importlib.util.spec_from_file_location("tecnicos_authoring", AUTHORING_PATH)
    if not spec or not spec.loader:
        raise RuntimeError(f"No se puede cargar {AUTHORING_PATH}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    module.SLIDES_TXT = CONTENT_DIR / "slides.txt"
    module.MANUAL_TXT = CONTENT_DIR / "manual.txt"
    return module


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def estimate_mp3_seconds(data: bytes) -> int:
    offset = 0
    if len(data) >= 10 and data[:3] == b"ID3":
        offset = 10 + ((data[6] & 0x7F) << 21) + ((data[7] & 0x7F) << 14)
        offset += ((data[8] & 0x7F) << 7) + (data[9] & 0x7F)
    mpeg1 = [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320]
    mpeg2 = [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160]
    for index in range(offset, min(len(data) - 4, offset + 65536)):
        if data[index] != 0xFF or data[index + 1] & 0xE0 != 0xE0:
            continue
        version = (data[index + 1] >> 3) & 0x03
        layer = (data[index + 1] >> 1) & 0x03
        bitrate_index = (data[index + 2] >> 4) & 0x0F
        if version == 1 or layer != 1 or bitrate_index in (0, 15):
            continue
        bitrate = (mpeg1 if version == 3 else mpeg2)[bitrate_index] * 1000
        if bitrate:
            return max(1, round(((len(data) - offset) * 8) / bitrate))
    raise ValueError("No se ha podido calcular la duración del MP3")


def render_slides(pdf: Path, output: Path) -> list[Path]:
    renderer = shutil.which("pdftoppm")
    if not renderer:
        raise RuntimeError("No se encuentra pdftoppm")
    slide_dir = output / "slides"
    slide_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="tecnicos-slides-") as temp:
        prefix = Path(temp) / "slide"
        subprocess.run(
            [
                renderer,
                "-jpeg",
                "-jpegopt",
                "quality=91,progressive=y",
                "-scale-to-x",
                "1600",
                "-scale-to-y",
                "900",
                str(pdf),
                str(prefix),
            ],
            check=True,
        )
        rendered = sorted(Path(temp).glob("slide-*.jpg"))
        if len(rendered) != 92:
            raise ValueError(f"Se esperaban 92 diapositivas y se renderizaron {len(rendered)}")
        result = []
        for number, source in enumerate(rendered, 1):
            destination = slide_dir / f"slide-{number:03d}.jpg"
            with Image.open(source) as image:
                image.convert("RGB").save(
                    destination, "JPEG", quality=91, optimize=True, progressive=True
                )
            result.append(destination)
    return result


def extract_audio(archive: Path, output: Path) -> list[tuple[Path, int]]:
    audio_dir = output / "audio"
    audio_dir.mkdir(parents=True, exist_ok=True)
    found: dict[int, bytes] = {}
    with zipfile.ZipFile(archive) as bundle:
        for info in bundle.infolist():
            match = re.match(r"^(\d{2})_Diapositiva_", Path(info.filename).name)
            if not match:
                continue
            found[int(match.group(1))] = bundle.read(info)
    if sorted(found) != list(range(1, 93)):
        raise ValueError("El ZIP no contiene exactamente los 92 audios de diapositiva")
    result = []
    for number in range(1, 93):
        path = audio_dir / f"slide-{number:03d}.mp3"
        path.write_bytes(found[number])
        result.append((path, estimate_mp3_seconds(found[number])))
    return result


def lesson_for_slide(number: int):
    for lesson in LESSONS:
        if lesson[4] <= number <= lesson[5]:
            return lesson
    raise ValueError(number)


def explanation_for(authoring, number, slide, meta, manual_parts) -> str:
    paragraphs = authoring.relevant_manual(slide, number, manual_parts, 780)
    if not paragraphs:
        fallback = authoring.BLOCK_PARTS[authoring.block_for_slide(number)]
        paragraphs = [authoring.strip_section_lead(manual_parts[index]) for index in fallback[:3]]
    slide_detail = authoring.slide_prose(slide, 220, number)
    parts = [
        "Objetivo",
        meta["purpose"],
        "Explicación detallada",
        *paragraphs,
    ]
    if slide_detail:
        parts.extend(["Lectura guiada de la diapositiva", slide_detail])
    parts.extend(
        [
            "Aplicación práctica",
            meta["example"],
            "Comprobación antes de continuar",
            "Identifica la condición real, la persona o equipo expuesto, la barrera aplicable, "
            "quién debe verificarla y qué evidencia permitirá autorizar la continuación.",
            "Idea clave",
            meta["key"],
        ]
    )
    text = "\n\n".join(authoring.clean_text(part) for part in parts if part)
    if not 500 <= len(text) <= 20000:
        raise ValueError(f"Extensión no válida en diapositiva {number}: {len(text)}")
    return text


def storage_path(version_id: str, relative: str) -> str:
    return f"{version_id}/{COURSE_SLUG}/{RELEASE}/{relative}"


def sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def build_sql(manifest: dict) -> str:
    course = manifest["course"]
    version = manifest["version"]
    units_json = json.dumps(manifest["units"], ensure_ascii=False, separators=(",", ":"))
    module_values = ",\n".join(
        f"({module['position']}, {sql_literal(module['id'])}::uuid, "
        f"{sql_literal(module['title'])}, {sql_literal(module['description'])})"
        for module in manifest["modules"]
    )
    lesson_values = ",\n".join(
        f"({lesson['ordinal']}, {lesson['module_position']}, {lesson['position']}, "
        f"{sql_literal(lesson['id'])}::uuid, {sql_literal(lesson['title'])}, "
        f"{lesson['duration_minutes']})"
        for lesson in manifest["lessons"]
    )
    materials = manifest["materials"]
    material_values = ",\n".join(
        "(" + ", ".join(
            [
                sql_literal(item["id"]) + "::uuid",
                sql_literal(version["id"]) + "::uuid",
                sql_literal(item["kind"]),
                sql_literal(item["title"]),
                sql_literal(item["description"]),
                sql_literal(item["storage_path"]),
                sql_literal(item["file_name"]),
                sql_literal(item["mime_type"]),
                str(item["size_bytes"]),
                str(item["page_count"]),
                "true",
                str(item["position"]),
                "false",
            ]
        ) + ")"
        for item in materials
    )
    return f"""-- Curso de técnicos titulados de exterior, versión inicial de 20 horas.
-- Se crea deliberadamente en borrador. Publicarlo exige una revisión separada.
begin;

insert into public.courses (
  id, slug, title, short_description, description, specialty, status,
  cover_storage_path
) values (
  {sql_literal(course['id'])}::uuid,
  {sql_literal(COURSE_SLUG)},
  {sql_literal(COURSE_TITLE)},
  'Formación preventiva inicial para técnicos titulados en actividades extractivas de exterior.',
  'Curso estructurado para anticipar, supervisar y poder detener trabajos cuando no pueda demostrarse una condición segura. Integra las 92 diapositivas, sus locuciones y la explicación detallada procedente del manual maestro.',
  'ITC 02.1.02 · Grupo 5.2.a · ET 2003-1-10',
  'draft',
  '/images/curso-tecnicos-exterior-portada.png'
)
on conflict (slug) do update set
  title = excluded.title,
  short_description = excluded.short_description,
  description = excluded.description,
  specialty = excluded.specialty,
  cover_storage_path = excluded.cover_storage_path,
  updated_at = now();

insert into public.course_versions (
  id, course_id, version_number, duration_hours, modality, objectives,
  target_audience, requirements, syllabus_summary, accreditation_label,
  accreditation_reference, practice_required, required_perfect_streak,
  video_completion_percent, price_net, tax_rate, currency, status
) values (
  {sql_literal(version['id'])}::uuid,
  (select id from public.courses where slug = {sql_literal(COURSE_SLUG)}),
  1, 20, 'hybrid',
  '["Anticipar peligros y cambios antes de iniciar o reanudar", "Supervisar controles con criterios verificables", "Detener, aislar y escalar cuando no exista evidencia suficiente", "Coordinar equipos, contratas e interferencias"]'::jsonb,
  '["Técnicos titulados que desempeñan funciones en actividades extractivas de exterior"]'::jsonb,
  '["Vinculación al puesto y asistencia a la impartición presencial exigida por la normativa aplicable"]'::jsonb,
  'Siete módulos: marco preventivo, definición de trabajos, técnicas preventivas, equipos y EPI, control del entorno, interferencias y normativa.',
  'Formación preventiva inicial de 20 horas',
  'ITC 02.1.02 · Grupo 5.2.a · ET 2003-1-10',
  true, 3, 95, null, 21, 'EUR', 'draft'
)
on conflict (id) do update set
  duration_hours = excluded.duration_hours,
  modality = excluded.modality,
  objectives = excluded.objectives,
  target_audience = excluded.target_audience,
  requirements = excluded.requirements,
  syllabus_summary = excluded.syllabus_summary,
  accreditation_label = excluded.accreditation_label,
  accreditation_reference = excluded.accreditation_reference,
  practice_required = excluded.practice_required,
  updated_at = now();

create temporary table _tex_modules (
  position integer, id uuid, title text, description text
) on commit drop;
insert into _tex_modules values
{module_values};

insert into public.course_modules (id, course_version_id, position, title, description)
select id, {sql_literal(version['id'])}::uuid, position, title, description
from _tex_modules
on conflict (id) do update set
  position = excluded.position,
  title = excluded.title,
  description = excluded.description,
  updated_at = now();

create temporary table _tex_lessons (
  ordinal integer, module_position integer, position integer, id uuid,
  title text, duration_minutes integer
) on commit drop;
insert into _tex_lessons values
{lesson_values};

insert into public.lessons (
  id, module_id, position, title, summary, kind, duration_minutes,
  sequential_required, active
)
select l.id, m.id, l.position, l.title,
  'Lección secuencial con una locución y una explicación detallada por diapositiva.',
  'mixed', l.duration_minutes, true, true
from _tex_lessons l
join _tex_modules m on m.position = l.module_position
on conflict (id) do update set
  module_id = excluded.module_id,
  position = excluded.position,
  title = excluded.title,
  summary = excluded.summary,
  kind = excluded.kind,
  duration_minutes = excluded.duration_minutes,
  sequential_required = excluded.sequential_required,
  active = excluded.active,
  updated_at = now();

create temporary table _tex_units on commit drop as
select * from jsonb_to_recordset($units${units_json}$units$::jsonb) as unit(
  slide_number integer,
  block_number integer,
  lesson_ordinal integer,
  segment_position integer,
  segment_id uuid,
  slide_id uuid,
  note_id uuid,
  title text,
  narration_text text,
  duration_seconds integer,
  audio_storage_path text,
  image_storage_path text,
  explanation text,
  key_points jsonb,
  stop_criterion text,
  source_pages text
);

insert into public.lesson_audio_segments (
  id, lesson_id, position, lesson_code, manual_chapter, title,
  narration_text, audio_storage_path, duration_seconds, published
)
select u.segment_id, l.id, u.segment_position,
  concat(u.lesson_ordinal, '.', u.segment_position),
  concat('Bloque ', u.block_number, ' · diapositiva ', lpad(u.slide_number::text, 2, '0')),
  u.title, u.narration_text, u.audio_storage_path, u.duration_seconds, true
from _tex_units u
join _tex_lessons l on l.ordinal = u.lesson_ordinal
on conflict (id) do update set
  lesson_id = excluded.lesson_id,
  position = excluded.position,
  lesson_code = excluded.lesson_code,
  manual_chapter = excluded.manual_chapter,
  title = excluded.title,
  narration_text = excluded.narration_text,
  audio_storage_path = excluded.audio_storage_path,
  duration_seconds = excluded.duration_seconds,
  published = excluded.published,
  updated_at = now();

insert into public.lesson_segment_slides (
  id, segment_id, position, title, body, image_storage_path,
  source_label, source_page, alt_text
)
select u.slide_id, u.segment_id, 1, u.title,
  concat('Objetivo: ', (u.key_points->>0), E'\n\nIdea clave: ', u.stop_criterion),
  u.image_storage_path,
  'Presentación InmínerCampus · Técnicos titulados de exterior',
  concat('Diapositiva ', u.slide_number),
  concat('Diapositiva ', u.slide_number, ': ', u.title)
from _tex_units u
on conflict (id) do update set
  title = excluded.title,
  body = excluded.body,
  image_storage_path = excluded.image_storage_path,
  source_label = excluded.source_label,
  source_page = excluded.source_page,
  alt_text = excluded.alt_text,
  updated_at = now();

insert into public.lesson_segment_notes (
  id, segment_id, summary, key_points, stop_criterion,
  source_label, source_pages, approved
)
select u.note_id, u.segment_id, u.explanation,
  array(select jsonb_array_elements_text(u.key_points)),
  u.stop_criterion,
  'Manual InmínerCampus · Técnicos titulados de exterior · edición 1.1',
  u.source_pages,
  true
from _tex_units u
on conflict (segment_id) do update set
  summary = excluded.summary,
  key_points = excluded.key_points,
  stop_criterion = excluded.stop_criterion,
  source_label = excluded.source_label,
  source_pages = excluded.source_pages,
  approved = excluded.approved,
  updated_at = now();

insert into public.course_materials (
  id, course_version_id, kind, title, description, storage_path,
  file_name, mime_type, size_bytes, page_count, downloadable, position,
  is_published
) values
{material_values}
on conflict (id) do update set
  title = excluded.title,
  description = excluded.description,
  storage_path = excluded.storage_path,
  file_name = excluded.file_name,
  mime_type = excluded.mime_type,
  size_bytes = excluded.size_bytes,
  page_count = excluded.page_count,
  downloadable = excluded.downloadable,
  position = excluded.position,
  is_published = excluded.is_published,
  updated_at = now();

do $$
declare
  modules_count integer;
  lessons_count integer;
  segments_count integer;
  slides_count integer;
  notes_count integer;
begin
  select count(*) into modules_count from public.course_modules
    where course_version_id = {sql_literal(version['id'])}::uuid;
  select count(*) into lessons_count from public.lessons l
    join public.course_modules m on m.id = l.module_id
    where m.course_version_id = {sql_literal(version['id'])}::uuid;
  select count(*) into segments_count from public.lesson_audio_segments s
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    where m.course_version_id = {sql_literal(version['id'])}::uuid;
  select count(*) into slides_count from public.lesson_segment_slides p
    join public.lesson_audio_segments s on s.id = p.segment_id
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    where m.course_version_id = {sql_literal(version['id'])}::uuid;
  select count(*) into notes_count from public.lesson_segment_notes n
    join public.lesson_audio_segments s on s.id = n.segment_id
    join public.lessons l on l.id = s.lesson_id
    join public.course_modules m on m.id = l.module_id
    where m.course_version_id = {sql_literal(version['id'])}::uuid;
  if modules_count <> 7 or lessons_count <> 10 or segments_count <> 92
     or slides_count <> 92 or notes_count <> 92 then
    raise exception 'Paquete incompleto: módulos %, lecciones %, audios %, diapositivas %, explicaciones %',
      modules_count, lessons_count, segments_count, slides_count, notes_count;
  end if;
end $$;

commit;
"""


def build(args):
    for source in (args.slides, args.manual, args.audio):
        if not source.exists():
            raise FileNotFoundError(source)
    if len(PdfReader(str(args.slides)).pages) != 92:
        raise ValueError("La presentación debe tener 92 páginas")
    if len(PdfReader(str(args.manual)).pages) != 38:
        raise ValueError("El manual debe tener 38 páginas")

    output = args.output
    output.mkdir(parents=True, exist_ok=True)
    slides_paths = render_slides(args.slides, output)
    audio_paths = extract_audio(args.audio, output)
    materials_dir = output / "materials"
    materials_dir.mkdir(parents=True, exist_ok=True)
    manual_copy = materials_dir / "manual-tecnicos-exterior-20h-v1.1.pdf"
    deck_copy = materials_dir / "presentacion-tecnicos-exterior-20h-v1.1.pdf"
    shutil.copy2(args.manual, manual_copy)
    shutil.copy2(args.slides, deck_copy)

    authoring = load_authoring()
    slides = authoring.load_slides()
    manual_parts = authoring.load_manual_parts()
    metadata = authoring.parse_meta()
    course_id = stable_uuid(f"course:{COURSE_SLUG}")
    version_id = stable_uuid(f"course:{COURSE_SLUG}:version:1")

    modules = []
    for position, block, title, minutes in MODULES:
        description = (
            "Módulo preparatorio integrado en el itinerario; no incrementa la duración reglada de 20 horas."
            if block == 0
            else f"Bloque oficial {block}. Duración reglada asignada: {minutes // 60} h."
        )
        modules.append(
            {
                "id": stable_uuid(f"{version_id}:module:{position}"),
                "position": position,
                "block": block,
                "title": title,
                "description": description,
            }
        )
    lessons = []
    for ordinal, module_position, position, title, start, end, minutes in LESSONS:
        lessons.append(
            {
                "id": stable_uuid(f"{version_id}:lesson:{ordinal}"),
                "ordinal": ordinal,
                "module_position": module_position,
                "position": position,
                "title": title,
                "slides": [start, end],
                "duration_minutes": minutes,
            }
        )

    units = []
    assets = []
    page_labels = {
        0: "Bloque 0 · marco de partida",
        1: "Bloque 1 · definición de los trabajos",
        2: "Bloque 2 · técnicas preventivas y de protección",
        3: "Bloque 3 · equipos, EPI y medios auxiliares",
        4: "Bloque 4 · control y vigilancia",
        5: "Bloque 5 · interferencias",
        6: "Bloque 6 · normativa y legislación",
    }
    for number, (slide, audio_item, slide_path) in enumerate(
        zip(slides, audio_paths, slides_paths), 1
    ):
        audio_path, duration = audio_item
        lesson = lesson_for_slide(number)
        lesson_ordinal, _, _, _, start, _, _ = lesson
        segment_position = number - start + 1
        block = authoring.block_for_slide(number)
        narration = "\n\n".join(
            authoring.narration_for(number, slide, metadata, manual_parts)
        )
        explanation = explanation_for(
            authoring, number, slide, metadata[number], manual_parts
        )
        image_storage = storage_path(version_id, f"slides/slide-{number:03d}.jpg")
        audio_storage = storage_path(version_id, f"audio/slide-{number:03d}.mp3")
        unit = {
            "slide_number": number,
            "block_number": block,
            "lesson_ordinal": lesson_ordinal,
            "segment_position": segment_position,
            "segment_id": stable_uuid(f"{version_id}:segment:{number}"),
            "slide_id": stable_uuid(f"{version_id}:slide:{number}"),
            "note_id": stable_uuid(f"{version_id}:note:{number}"),
            "title": slide["title"][:240],
            "narration_text": narration,
            "duration_seconds": duration,
            "audio_storage_path": audio_storage,
            "image_storage_path": image_storage,
            "explanation": explanation,
            "key_points": [metadata[number]["purpose"], metadata[number]["key"]],
            "stop_criterion": metadata[number]["key"],
            "source_pages": page_labels[block],
        }
        units.append(unit)
        for local_path, remote_path, mime in (
            (slide_path, image_storage, "image/jpeg"),
            (audio_path, audio_storage, "audio/mpeg"),
        ):
            assets.append(
                {
                    "local_path": str(local_path.relative_to(output)),
                    "storage_path": remote_path,
                    "mime_type": mime,
                    "size_bytes": local_path.stat().st_size,
                    "sha256": sha256(local_path),
                }
            )

    materials = []
    for position, (kind, title, description, path, pages) in enumerate(
        [
            (
                "manual",
                "Manual del curso de técnicos titulados de exterior",
                "Manual maestro InmínerCampus, edición 1.1.",
                manual_copy,
                38,
            ),
            (
                "presentation",
                "Presentación del curso de técnicos titulados de exterior",
                "Presentación completa con 92 diapositivas.",
                deck_copy,
                92,
            ),
        ],
        1,
    ):
        remote = storage_path(version_id, f"materials/{path.name}")
        item = {
            "id": stable_uuid(f"{version_id}:material:{kind}"),
            "kind": kind,
            "title": title,
            "description": description,
            "storage_path": remote,
            "file_name": path.name,
            "mime_type": "application/pdf",
            "size_bytes": path.stat().st_size,
            "page_count": pages,
            "position": position,
        }
        materials.append(item)
        assets.append(
            {
                "local_path": str(path.relative_to(output)),
                "storage_path": remote,
                "mime_type": "application/pdf",
                "size_bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
        )

    manifest = {
        "schema_version": 1,
        "bucket": BUCKET,
        "course": {"id": course_id, "slug": COURSE_SLUG, "title": COURSE_TITLE},
        "version": {"id": version_id, "number": 1, "status": "draft"},
        "modules": modules,
        "lessons": lessons,
        "units": units,
        "materials": materials,
        "assets": assets,
    }
    if len(units) != 92 or len(assets) != 186:
        raise AssertionError("Recuento del paquete incorrecto")
    if sum(item["duration_minutes"] for item in lessons) != 1200:
        raise AssertionError("La distribución no suma las 20 horas regladas")
    if any(not 60 <= unit["duration_seconds"] <= 240 for unit in units):
        raise AssertionError("Hay un audio fuera del intervalo editorial de 1 a 4 minutos")

    MANIFEST_PATH.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    MIGRATION_PATH.write_text(build_sql(manifest), encoding="utf-8")

    cover_png = ROOT / "public/images/curso-tecnicos-exterior-portada.png"
    cover_webp = ROOT / "public/images/curso-tecnicos-exterior-portada.webp"
    with Image.open(slides_paths[0]) as cover:
        cover.convert("RGB").save(cover_png, "PNG", optimize=True)
        cover.convert("RGB").save(cover_webp, "WEBP", quality=86, method=6)

    print(json.dumps({
        "course_id": course_id,
        "version_id": version_id,
        "modules": len(modules),
        "lessons": len(lessons),
        "units": len(units),
        "assets": len(assets),
        "audio_seconds": sum(unit["duration_seconds"] for unit in units),
        "manifest": str(MANIFEST_PATH),
        "migration": str(MIGRATION_PATH),
        "asset_root": str(output),
    }, ensure_ascii=False, indent=2))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--slides", type=Path, required=True)
    parser.add_argument("--manual", type=Path, required=True)
    parser.add_argument("--audio", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    return parser.parse_args()


if __name__ == "__main__":
    build(parse_args())
