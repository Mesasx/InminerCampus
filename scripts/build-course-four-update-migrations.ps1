param(
  [Parameter(Mandatory = $true)]
  [string]$PresentationPath,
  [Parameter(Mandatory = $true)]
  [string[]]$MigrationPaths,
  [string]$Release = 'course-4-20260813-v3'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

if ($MigrationPaths.Count -ne 5) {
  throw "Se necesitan exactamente cinco rutas de migración."
}

function Normalize-Text([AllowNull()][string]$Value) {
  if ($null -eq $Value) { return '' }
  return (($Value -replace '\s+', ' ').Trim())
}

function Sql-Literal([AllowNull()][string]$Value) {
  if ($null -eq $Value) { return 'null' }
  return "'$(($Value -replace "'", "''").Trim())'"
}

function Read-SlideTexts($Zip, [int]$SlideNumber) {
  $entry = $Zip.GetEntry("ppt/slides/slide$SlideNumber.xml")
  if (-not $entry) { throw "No existe la diapositiva $SlideNumber." }
  $reader = [IO.StreamReader]::new($entry.Open())
  try {
    $xml = [xml]$reader.ReadToEnd()
    return @($xml.GetElementsByTagName('a:t') | ForEach-Object {
      Normalize-Text $_.InnerText
    } | Where-Object { $_ })
  } finally { $reader.Dispose() }
}

$source = Resolve-Path -LiteralPath $PresentationPath
$zip = [IO.Compression.ZipFile]::OpenRead($source)
$details = [Collections.Generic.List[object]]::new()

try {
  $slideCount = @($zip.Entries | Where-Object FullName -Match '^ppt/slides/slide\d+\.xml$').Count
  if ($slideCount -ne 50) {
    throw "La actualización del curso 4 contiene $slideCount diapositivas; se esperaban 50."
  }

  for ($page = 1; $page -le 50; $page += 1) {
    $texts = @(Read-SlideTexts $zip $page)
    $block = [Math]::Floor(($page - 1) / 10) + 1
    $part = (($page - 1) % 10) + 1
    $partLabel = "CURSO 4 · PARTE $block.$part"
    $partIndex = [Array]::IndexOf($texts, $partLabel)
    $markerIndex = -1
    for ($index = 0; $index -lt $texts.Count; $index += 1) {
      if ($texts[$index] -in @('OBJETIVO DE APRENDIZAJE', 'CLAVES DE LA OPERACIÓN')) {
        $markerIndex = $index
        break
      }
    }
    if ($partIndex -lt 0 -or $markerIndex -le $partIndex) {
      throw "Diapositiva ${page}: no se reconoce la estructura de la parte $block.$part."
    }

    $title = Normalize-Text $texts[$markerIndex - 1]
    $keyPoints = @()
    for ($index = $markerIndex + 1; $index -lt $texts.Count; $index += 1) {
      $value = Normalize-Text $texts[$index]
      if ($value -like 'INMÍNERCAMPUS*' -or $value -match '^\d{2}\s*/\s*50$') { continue }
      $keyPoints += $value
    }
    if ($title.Length -lt 5 -or $keyPoints.Count -lt 3) {
      throw "Diapositiva ${page}: el detalle didáctico es insuficiente."
    }

    $details.Add([pscustomobject]@{
      Block = $block
      Part = $part
      Page = $page
      Title = $title
      Summary = Normalize-Text ($keyPoints -join ' ')
      KeyPoints = $keyPoints
    }) | Out-Null
  }
} finally { $zip.Dispose() }

for ($block = 1; $block -le 5; $block += 1) {
  $rows = @($details | Where-Object Block -eq $block | ForEach-Object {
    $keyPointsSql = ($_.KeyPoints | ForEach-Object { Sql-Literal $_ }) -join ', '
    '  ({0}, {1}, {2}, {3}, array[{4}]::text[])' -f
      $_.Part,
      $_.Page,
      (Sql-Literal $_.Title),
      (Sql-Literal $_.Summary),
      $keyPointsSql
  })
  if ($rows.Count -ne 10) { throw "Bloque ${block}: se esperaban 10 partes." }
  $valuesSql = $rows -join ",`r`n"
  $migrationPath = $MigrationPaths[$block - 1]
  $sql = @"
-- Actualiza el bloque $block del curso 4 con la presentación oficial de 50 diapositivas.

begin;

create temporary table course_four_slide_updates (
  part_position integer primary key,
  source_page integer not null,
  title text not null,
  summary text not null,
  key_points text[] not null
) on commit drop;

insert into course_four_slide_updates values
$valuesSql;

do `$`$
declare
  target_version_id uuid;
  object_count integer;
begin
  select version.id into strict target_version_id
  from public.course_versions version
  join public.courses course on course.id = version.course_id
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20;

  select count(*) into object_count
  from storage.objects object
  where object.bucket_id = 'course-materials'
    and object.name like target_version_id::text
      || '/slides/$Release/block-$block/%';

  if object_count <> 10 then
    raise exception 'Curso 4, bloque ${block}: se esperaban 10 imágenes y existen %.', object_count;
  end if;
end `$`$;

update public.lesson_audio_segments segment
set title = detail.title,
    narration_text = detail.summary,
    published = true,
    updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_four_slide_updates detail on true
where segment.lesson_id = lesson.id
  and segment.position = detail.part_position
  and module.position = $block
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

update public.lesson_segment_notes note
set summary = detail.summary,
    key_points = detail.key_points,
    source_label = 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
    source_pages = 'Diapositiva ' || detail.source_page::text || '/50',
    approved = true,
    updated_at = now()
from public.lesson_audio_segments segment
join public.lessons lesson on lesson.id = segment.lesson_id
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_four_slide_updates detail on detail.part_position = segment.position
where note.segment_id = segment.id
  and module.position = $block
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

delete from public.lesson_segment_slides slide
using public.lesson_audio_segments segment,
      public.lessons lesson,
      public.course_modules module,
      public.course_versions version,
      public.courses course
where slide.segment_id = segment.id
  and segment.lesson_id = lesson.id
  and lesson.module_id = module.id
  and module.course_version_id = version.id
  and version.course_id = course.id
  and module.position = $block
  and course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

insert into public.lesson_segment_slides (
  segment_id, position, title, body, image_storage_path, image_external_url,
  source_label, source_page, alt_text
)
select
  segment.id,
  1,
  detail.title,
  detail.summary,
  version.id::text || '/slides/$Release/block-$block/audio-$block-'
    || lpad(detail.part_position::text, 2, '0') || '/slide-01.jpg',
  null,
  'Presentación oficial Inmíner · Curso 4 (actualización 50 diapositivas)',
  detail.source_page::text,
  'Curso 4, bloque $block, parte $block.' || detail.part_position::text
from public.courses course
join public.course_versions version on version.course_id = course.id
join public.course_modules module on module.course_version_id = version.id and module.position = $block
join public.lessons lesson on lesson.module_id = module.id
join public.lesson_audio_segments segment on segment.lesson_id = lesson.id
join course_four_slide_updates detail on detail.part_position = segment.position
where course.slug = 'operador-maquinaria-arranque-carga-viales'
  and version.duration_hours = 20;

do `$`$
declare
  updated_segments integer;
  updated_slides integer;
  updated_notes integer;
begin
  select count(distinct segment.id), count(distinct slide.id), count(distinct note.segment_id)
  into updated_segments, updated_slides, updated_notes
  from public.courses course
  join public.course_versions version on version.course_id = course.id
  join public.course_modules module on module.course_version_id = version.id and module.position = $block
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id
  join public.lesson_segment_slides slide on slide.segment_id = segment.id
    and slide.image_storage_path like version.id::text || '/slides/$Release/%'
  join public.lesson_segment_notes note on note.segment_id = segment.id and note.approved
  where course.slug = 'operador-maquinaria-arranque-carga-viales'
    and version.duration_hours = 20
    and segment.published
    and length(trim(segment.narration_text)) >= 10;

  if updated_segments <> 10 or updated_slides <> 10 or updated_notes <> 10 then
    raise exception 'Curso 4, bloque $block incompleto: % partes, % diapositivas, % fichas.',
      updated_segments, updated_slides, updated_notes;
  end if;
end `$`$;

commit;
"@

  Set-Content -LiteralPath $migrationPath -Value $sql -Encoding UTF8
  Write-Output "Bloque ${block}: $migrationPath"
}

Write-Output "Partes procesadas: $($details.Count)"
