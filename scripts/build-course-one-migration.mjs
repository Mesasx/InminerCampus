import { readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'
import process from 'node:process'

const root = process.cwd()
const manifestPath = path.join(root, 'content', 'course-1-complete.manifest.json')
const audioInventoryPath = path.join(root, 'content', 'course-1-audio-inventory.json')
const outputPath = path.join(
  root,
  'supabase',
  'migrations',
  '202608100002_finalize_course_one_five_hours.sql',
)

const manifest = JSON.parse(await readFile(manifestPath, 'utf8'))
const audioInventory = JSON.parse(
  (await readFile(audioInventoryPath, 'utf8')).replace(/^\uFEFF/, ''),
)

function sqlText(value) {
  return `E'${String(value)
    .replaceAll('\\', '\\\\')
    .replaceAll("'", "''")
    .replaceAll('\r', '\\r')
    .replaceAll('\n', '\\n')}'`
}

function sqlArray(values) {
  return `array[${values.map(sqlText).join(', ')}]::text[]`
}

function sourcePages(source) {
  const match = source.match(/páginas? PDF (.+)$/i)
  return match?.[1] ?? 'consulta general'
}

const audioByPart = new Map(audioInventory.audios.map((audio) => [audio.part, audio]))
const partRows = manifest.audios.map((entry) => {
  const audio = audioByPart.get(entry.part)
  if (!audio) throw new Error(`Falta el inventario de audio ${entry.part}`)
  return `(${entry.block}, ${entry.position}, ${sqlText(entry.blockTitle)}, ${sqlText(entry.title)}, ${sqlText(entry.narration)}, ${sqlText(entry.explanation)}, ${sqlArray(entry.keyPoints)}, ${sqlText(entry.stopCriterion)}, ${sqlText(entry.source)}, ${sqlText(sourcePages(entry.source))}, ${sqlText(audio.storagePathTemplate)}, ${audio.durationSeconds}, ${audio.sizeBytes})`
})

const slideRows = manifest.audios.flatMap((entry) =>
  entry.slides.map(
    (slide) =>
      `(${entry.block}, ${entry.position}, ${slide.position}, ${sqlText(slide.title)}, ${sqlText(slide.body)}, ${sqlText(slide.storagePath)}, ${sqlText(slide.sourceLabel)}, ${sqlText(slide.sourcePage)}, ${sqlText(slide.altText)})`,
  ),
)

if (manifest.courseSlug !== 'operador-maquinaria-arranque-carga-viales') {
  throw new Error('Slug inesperado en el manifiesto')
}
if (manifest.durationHours !== 5 || partRows.length !== 50 || slideRows.length !== 100) {
  throw new Error('El manifiesto no representa 50 audios y 100 diapositivas de cinco horas')
}

const sql = `begin;

alter table public.lesson_segment_notes
  add column if not exists stop_criterion text not null default '';

alter table public.lesson_segment_notes
  drop constraint if exists lesson_segment_notes_stop_criterion_length;
alter table public.lesson_segment_notes
  add constraint lesson_segment_notes_stop_criterion_length
  check (stop_criterion = '' or char_length(stop_criterion) between 10 and 2000);

create temporary table course_one_parts (
  block_position integer not null,
  segment_position integer not null,
  block_title text not null,
  title text not null,
  narration text not null,
  explanation text not null,
  key_points text[] not null,
  stop_criterion text not null,
  source_label text not null,
  source_pages text not null,
  audio_path_template text not null,
  duration_seconds integer not null,
  size_bytes bigint not null,
  primary key (block_position, segment_position)
) on commit drop;

insert into course_one_parts values
${partRows.join(',\n')};

create temporary table course_one_slides (
  block_position integer not null,
  segment_position integer not null,
  slide_position integer not null,
  title text not null,
  body text not null,
  storage_path text not null,
  source_label text not null,
  source_page text not null,
  alt_text text not null,
  primary key (block_position, segment_position, slide_position)
) on commit drop;

insert into course_one_slides values
${slideRows.join(',\n')};

create temporary table course_one_target_version on commit drop as
select cv.id
from public.course_versions cv
join public.courses c on c.id = cv.course_id
where c.slug = 'operador-maquinaria-arranque-carga-viales'
  and cv.duration_hours = 5
  and cv.status = 'published';

do $$
begin
  if (select count(*) from course_one_target_version) <> 1 then
    raise exception 'Se esperaba una única versión publicada de cinco horas para el Curso 1';
  end if;
  if (select count(*) from course_one_parts) <> 50 then
    raise exception 'El manifiesto debe contener exactamente 50 audios';
  end if;
  if (select count(*) from course_one_slides) <> 100 then
    raise exception 'El manifiesto debe contener exactamente 100 diapositivas';
  end if;
end;
$$;

update public.course_modules module
set title = source.block_title,
    description = 'Bloque formativo con diez apartados de audio, apoyo visual y contenido preventivo.',
    updated_at = now()
from (
  select distinct block_position, block_title from course_one_parts
) source,
course_one_target_version target
where module.course_version_id = target.id
  and module.position = source.block_position
  and module.position between 1 and 5;

do $$
begin
  if (
    select count(*)
    from public.course_modules module
    join course_one_target_version target on target.id = module.course_version_id
    where module.position between 1 and 5
  ) <> 5 then
    raise exception 'No se pudieron resolver exactamente los módulos 1 a 5 del Curso 1';
  end if;

  if exists (
    select 1
    from public.lesson_audio_progress progress
    join public.lesson_audio_segments segment on segment.id = progress.segment_id
    join public.lessons lesson on lesson.id = segment.lesson_id
    join public.course_modules module on module.id = lesson.module_id
    join course_one_target_version target on target.id = module.course_version_id
    where module.position > 5
  ) then
    raise exception 'No se elimina el sexto módulo porque contiene progreso de audio';
  end if;

  if exists (
    select 1
    from public.lesson_progress progress
    join public.lessons lesson on lesson.id = progress.lesson_id
    join public.course_modules module on module.id = lesson.module_id
    join course_one_target_version target on target.id = module.course_version_id
    where module.position > 5
      and (progress.status <> 'locked' or progress.completed_at is not null)
  ) then
    raise exception 'No se elimina el sexto módulo porque contiene progreso real';
  end if;
end;
$$;

delete from public.course_modules module
using course_one_target_version target
where module.course_version_id = target.id
  and module.position > 5;

create temporary table course_one_lessons on commit drop as
select module.position as block_position, lesson.id as lesson_id
from public.course_modules module
join course_one_target_version target on target.id = module.course_version_id
join public.lessons lesson on lesson.module_id = module.id
where module.position between 1 and 5
  and lesson.position = 1;

do $$
begin
  if (select count(*) from course_one_lessons) <> 5 then
    raise exception 'Se esperaba una lección principal por cada uno de los cinco bloques';
  end if;
end;
$$;

update public.lessons lesson
set title = format('Bloque %s · %s', part.block_position, part.block_title),
    summary = 'Diez apartados secuenciales con audio, dos diapositivas y explicación preventiva.',
    duration_minutes = 60,
    active = true,
    updated_at = now()
from course_one_lessons target_lesson
join (
  select distinct block_position, block_title from course_one_parts
) part using (block_position)
where lesson.id = target_lesson.lesson_id;

delete from public.lesson_audio_segments segment
using course_one_lessons target_lesson
where segment.lesson_id = target_lesson.lesson_id
  and not exists (
    select 1 from course_one_parts part
    where part.block_position = target_lesson.block_position
      and part.segment_position = segment.position
  );

insert into public.lesson_audio_segments (
  lesson_id,
  position,
  title,
  narration_text,
  audio_storage_path,
  audio_external_url,
  duration_seconds,
  published
)
select
  target_lesson.lesson_id,
  part.segment_position,
  part.title,
  part.narration,
  replace(part.audio_path_template, '{courseVersionId}', target.id::text),
  null,
  part.duration_seconds,
  true
from course_one_parts part
join course_one_lessons target_lesson using (block_position)
cross join course_one_target_version target
on conflict (lesson_id, position) do update
set title = excluded.title,
    narration_text = excluded.narration_text,
    audio_storage_path = excluded.audio_storage_path,
    audio_external_url = null,
    duration_seconds = excluded.duration_seconds,
    published = true,
    updated_at = now();

create temporary table course_one_segments on commit drop as
select
  target_lesson.block_position,
  segment.position as segment_position,
  segment.id as segment_id
from course_one_lessons target_lesson
join public.lesson_audio_segments segment on segment.lesson_id = target_lesson.lesson_id
where segment.position between 1 and 10;

delete from public.lesson_segment_slides slide
using course_one_segments target_segment
where slide.segment_id = target_segment.segment_id;

insert into public.lesson_segment_slides (
  segment_id,
  position,
  title,
  body,
  image_storage_path,
  image_external_url,
  source_label,
  source_page,
  alt_text
)
select
  target_segment.segment_id,
  slide.slide_position,
  slide.title,
  slide.body,
  slide.storage_path,
  null,
  slide.source_label,
  slide.source_page,
  slide.alt_text
from course_one_slides slide
join course_one_segments target_segment
  on target_segment.block_position = slide.block_position
 and target_segment.segment_position = slide.segment_position;

insert into public.lesson_segment_notes (
  segment_id,
  summary,
  key_points,
  stop_criterion,
  source_label,
  source_pages,
  approved
)
select
  target_segment.segment_id,
  part.explanation,
  part.key_points,
  part.stop_criterion,
  part.source_label,
  part.source_pages,
  true
from course_one_parts part
join course_one_segments target_segment
  on target_segment.block_position = part.block_position
 and target_segment.segment_position = part.segment_position
on conflict (segment_id) do update
set summary = excluded.summary,
    key_points = excluded.key_points,
    stop_criterion = excluded.stop_criterion,
    source_label = excluded.source_label,
    source_pages = excluded.source_pages,
    approved = true,
    updated_at = now();

delete from public.lesson_resources resource
using course_one_lessons target_lesson
where resource.lesson_id = target_lesson.lesson_id
  and resource.kind = 'pdf'
  and (
    resource.title = 'Manual oficial del operador de maquinaria de arranque, carga y viales'
    or resource.external_url like '%Operador_maquinaria_arranque_carga_viales.pdf%'
    or resource.storage_path like '%/resources/manual-operador-maquinaria-arranque-ET-2001-1-08.pdf'
  );

insert into public.lesson_resources (
  lesson_id,
  kind,
  title,
  storage_path,
  external_url,
  mime_type,
  size_bytes,
  downloadable,
  required,
  position
)
select
  target_lesson.lesson_id,
  'pdf'::public.resource_kind,
  'Manual oficial del operador de maquinaria de arranque, carga y viales',
  target.id::text || '/resources/manual-operador-maquinaria-arranque-ET-2001-1-08.pdf',
  null,
  'application/pdf',
  16817673,
  false,
  false,
  1
from course_one_lessons target_lesson
cross join course_one_target_version target;

drop policy if exists course_materials_enrolled_read on storage.objects;
create policy course_materials_enrolled_read
on storage.objects
for select
to authenticated
using (
  bucket_id = 'course-materials'
  and (
    (
      (storage.foldername(name))[1] ~ '^[0-9a-fA-F-]{36}$'
      and (
        (select app_private.current_user_is_enrolled(((storage.foldername(name))[1])::uuid))
        or (select app_private.current_user_has_role(array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]))
      )
    )
    or (
      name like 'course-1/5h/%'
      and (
        exists (
          select 1
          from public.course_versions cv
          join public.courses c on c.id = cv.course_id
          where c.slug = 'operador-maquinaria-arranque-carga-viales'
            and cv.duration_hours = 5
            and cv.status = 'published'
            and (select app_private.current_user_is_enrolled(cv.id))
        )
        or (select app_private.current_user_has_role(array[
          'tutor'::public.app_role,
          'administrador'::public.app_role,
          'superadministrador'::public.app_role
        ]))
      )
    )
  )
);

do $$
declare
  target_id uuid;
begin
  select id into target_id from course_one_target_version;

  if (
    select count(*) from storage.objects object
    join course_one_slides slide on slide.storage_path = object.name
    where object.bucket_id = 'course-materials'
      and coalesce((object.metadata ->> 'size')::bigint, 0) > 10000
  ) <> 100 then
    raise exception 'Los 100 PNG privados no están disponibles o tienen un tamaño inválido';
  end if;

  if (
    select count(*) from storage.objects object
    join course_one_parts part
      on object.name = replace(part.audio_path_template, '{courseVersionId}', target_id::text)
    where object.bucket_id = 'course-materials'
      and coalesce((object.metadata ->> 'size')::bigint, 0) = part.size_bytes
  ) <> 50 then
    raise exception 'Los 50 audios privados no están disponibles con el tamaño validado';
  end if;

  if not exists (
    select 1 from storage.objects object
    where object.bucket_id = 'course-materials'
      and object.name = target_id::text || '/resources/manual-operador-maquinaria-arranque-ET-2001-1-08.pdf'
      and coalesce((object.metadata ->> 'size')::bigint, 0) = 16817673
  ) then
    raise exception 'El manual PDF privado no está disponible con el tamaño validado';
  end if;

  if (select count(*) from course_one_segments) <> 50 then
    raise exception 'El Curso 1 no contiene exactamente 50 segmentos';
  end if;
  if exists (
    select 1 from course_one_segments segment
    left join public.lesson_segment_slides slide on slide.segment_id = segment.segment_id
    group by segment.segment_id having count(slide.id) <> 2
  ) then
    raise exception 'Cada audio del Curso 1 debe tener exactamente dos diapositivas';
  end if;
  if (
    select count(*) from public.lesson_segment_notes note
    join course_one_segments segment on segment.segment_id = note.segment_id
    where note.approved
      and cardinality(note.key_points) = 3
      and char_length(note.stop_criterion) >= 10
  ) <> 50 then
    raise exception 'Los 50 audios deben tener explicación, tres puntos y criterio de parada';
  end if;
  if (
    select count(*) from public.lesson_resources resource
    join course_one_lessons lesson on lesson.lesson_id = resource.lesson_id
    where resource.kind = 'pdf'
      and resource.storage_path = target_id::text || '/resources/manual-operador-maquinaria-arranque-ET-2001-1-08.pdf'
  ) <> 5 then
    raise exception 'El manual PDF debe estar vinculado a los cinco bloques';
  end if;
end;
$$;

commit;
`

await writeFile(outputPath, sql, 'utf8')
console.log(`Migración generada: ${path.relative(root, outputPath)}`)
