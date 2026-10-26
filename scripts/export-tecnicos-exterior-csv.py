#!/usr/bin/env python3
"""Exporta el manifiesto del curso a CSV para el importador de Supabase."""

from __future__ import annotations

import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "content/tecnicos-exterior-20h/course-manifest.json"
OUT = ROOT / "tmp/tecnicos-exterior-20h/csv"


def write(name: str, rows: list[dict]) -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / f"{name}.csv"
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    print(path)


def pg_array(values: list[str]) -> str:
    return "{" + ",".join('"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"' for value in values) + "}"


data = json.loads(MANIFEST.read_text(encoding="utf-8"))
course_id = data["course"]["id"]
version_id = data["version"]["id"]

write(
    "01_courses",
    [
        {
            "id": course_id,
            "slug": data["course"]["slug"],
            "title": data["course"]["title"],
            "short_description": "Formación preventiva inicial para técnicos titulados en actividades extractivas de exterior.",
            "description": "Curso estructurado para anticipar, supervisar y poder detener trabajos cuando no pueda demostrarse una condición segura. Integra 92 diapositivas, sus locuciones y la explicación detallada procedente del manual maestro.",
            "specialty": "ITC 02.1.02 · Grupo 5.2.a · ET 2003-1-10",
            "status": "draft",
            "cover_storage_path": "/images/curso-tecnicos-exterior-portada.png",
        }
    ],
)

write(
    "02_course_versions",
    [
        {
            "id": version_id,
            "course_id": course_id,
            "version_number": 1,
            "duration_hours": 20,
            "modality": "hybrid",
            "objectives": json.dumps(
                [
                    "Anticipar peligros y cambios antes de iniciar o reanudar",
                    "Supervisar controles con criterios verificables",
                    "Detener, aislar y escalar cuando no exista evidencia suficiente",
                    "Coordinar equipos, contratas e interferencias",
                ],
                ensure_ascii=False,
            ),
            "target_audience": json.dumps(
                ["Técnicos titulados que desempeñan funciones en actividades extractivas de exterior"],
                ensure_ascii=False,
            ),
            "requirements": json.dumps(
                ["Vinculación al puesto y asistencia a la impartición presencial exigida por la normativa aplicable"],
                ensure_ascii=False,
            ),
            "syllabus_summary": "Siete módulos: marco preventivo, definición de trabajos, técnicas preventivas, equipos y EPI, control del entorno, interferencias y normativa.",
            "accreditation_label": "Formación preventiva inicial de 20 horas",
            "accreditation_reference": "ITC 02.1.02 · Grupo 5.2.a · ET 2003-1-10",
            "practice_required": "true",
            "required_perfect_streak": 2,
            "video_completion_percent": 95,
            "tax_rate": 21,
            "currency": "EUR",
            "status": "draft",
        }
    ],
)

write(
    "03_course_modules",
    [
        {
            "id": item["id"],
            "course_version_id": version_id,
            "position": item["position"],
            "title": item["title"],
            "description": item["description"],
        }
        for item in data["modules"]
    ],
)

module_ids = {item["position"]: item["id"] for item in data["modules"]}
write(
    "04_lessons",
    [
        {
            "id": item["id"],
            "module_id": module_ids[item["module_position"]],
            "position": item["position"],
            "title": item["title"],
            "summary": "Lección secuencial con una locución y una explicación detallada por diapositiva.",
            "kind": "mixed",
            "duration_minutes": item["duration_minutes"],
            "sequential_required": "true",
            "active": "true",
        }
        for item in data["lessons"]
    ],
)

lesson_ids = {item["ordinal"]: item["id"] for item in data["lessons"]}
write(
    "05_lesson_audio_segments",
    [
        {
            "id": unit["segment_id"],
            "lesson_id": lesson_ids[unit["lesson_ordinal"]],
            "position": unit["segment_position"],
            "lesson_code": f'{unit["lesson_ordinal"]}.{unit["segment_position"]}',
            "manual_chapter": f'Bloque {unit["block_number"]} · diapositiva {unit["slide_number"]:02d}',
            "title": unit["title"],
            "narration_text": unit["narration_text"],
            "audio_storage_path": unit["audio_storage_path"],
            "duration_seconds": unit["duration_seconds"],
            "published": "true",
        }
        for unit in data["units"]
    ],
)

write(
    "06_lesson_segment_slides",
    [
        {
            "id": unit["slide_id"],
            "segment_id": unit["segment_id"],
            "position": 1,
            "title": unit["title"],
            "body": f'Objetivo: {unit["key_points"][0]}\n\nIdea clave: {unit["stop_criterion"]}',
            "image_storage_path": unit["image_storage_path"],
            "source_label": "Presentación InmínerCampus · Técnicos titulados de exterior",
            "source_page": f'Diapositiva {unit["slide_number"]}',
            "alt_text": f'Diapositiva {unit["slide_number"]}: {unit["title"]}',
        }
        for unit in data["units"]
    ],
)

write(
    "07_lesson_segment_notes",
    [
        {
            "id": unit["note_id"],
            "segment_id": unit["segment_id"],
            "summary": unit["explanation"],
            "key_points": pg_array(unit["key_points"]),
            "stop_criterion": unit["stop_criterion"],
            "source_label": "Manual InmínerCampus · Técnicos titulados de exterior · edición 1.1",
            "source_pages": unit["source_pages"],
            "approved": "true",
        }
        for unit in data["units"]
    ],
)

write(
    "08_course_materials",
    [
        {
            "id": item["id"],
            "course_version_id": version_id,
            "kind": item["kind"],
            "title": item["title"],
            "description": item["description"],
            "storage_path": item["storage_path"],
            "mime_type": item["mime_type"],
            "size_bytes": item["size_bytes"],
            "downloadable": "true",
            "position": item["position"],
            "file_name": item["file_name"],
            "page_count": item["page_count"],
            "is_published": "false",
        }
        for item in data["materials"]
    ],
)
