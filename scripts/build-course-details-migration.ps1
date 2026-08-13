param(
  [Parameter(Mandatory = $true)]
  [string]$MigrationPath
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$deckRoot = Join-Path $repositoryRoot 'Contenido Cursos\Diapositivas y documentos\Diapositivas cursos'
$courseTwoManifestPath = Join-Path $repositoryRoot 'Contenido Cursos\Diapositivas y documentos\Curso 2\course-2-complete.manifest.json'

$decks = @(
  @{
    Slug = 'operador-maquinaria-transporte-camion-volquete'
    DurationHours = 5
    Filename = 'Curso_2_Transporte_Camion_Volquete_Diapositivas_InminerCampus.pptx'
    SourceLabel = 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 2'
    Manifest = $true
  },
  @{
    Slug = 'operador-maquinaria-arranque-carga-viales'
    DurationHours = 20
    Filename = 'Curso_4_Maquinaria_Arranque_Carga_y_Viales_InminerCampus_MEJORADO.pptx'
    SourceLabel = 'ET 2001-1-08 · Presentación oficial Inmíner · Curso 4'
  },
  @{
    Slug = 'operador-maquinaria-transporte-camion-volquete'
    DurationHours = 20
    Filename = 'Curso_5_Transporte_Camion_y_Volquete_InminerCampus_FOTOS_GENERADAS.pptx'
    SourceLabel = 'ET 2000-1-08 · Presentación oficial Inmíner · Curso 5'
  },
  @{
    Slug = 'prevencion-polvo-silice-cristalina-respirable'
    DurationHours = 20
    Filename = 'Curso_6_Polvo_y_Silice_20H_InminerCampus_VARIADO_ALTA_CALIDAD (1).pptx'
    SourceLabel = 'Presentación oficial Inmíner · Curso 6'
  }
)

function Sql-Literal([AllowNull()][string]$Value) {
  if ($null -eq $Value) { return 'null' }
  return "'$(($Value -replace "'", "''").Trim())'"
}

function Normalize-Text([AllowNull()][string]$Value) {
  if (-not $Value) { return '' }
  return (($Value -replace '\s+', ' ').Trim())
}

function Read-SlideTexts($Zip, [int]$SlideNumber) {
  $entry = $Zip.GetEntry("ppt/slides/slide$SlideNumber.xml")
  if (-not $entry) { throw "No existe la diapositiva $SlideNumber." }
  $reader = [IO.StreamReader]::new($entry.Open(), [Text.Encoding]::UTF8)
  try { $xml = [xml]$reader.ReadToEnd() } finally { $reader.Dispose() }
  $namespaces = [Xml.XmlNamespaceManager]::new($xml.NameTable)
  $namespaces.AddNamespace('a', 'http://schemas.openxmlformats.org/drawingml/2006/main')
  return @($xml.SelectNodes('//a:t', $namespaces) | ForEach-Object { Normalize-Text $_.InnerText } | Where-Object { $_ })
}

function Index-OfText($Items, [string]$Expected) {
  for ($index = 0; $index -lt $Items.Count; $index += 1) {
    if ($Items[$index] -eq $Expected) { return $index }
  }
  return -1
}

function Build-DeckDetail($Deck, $Zip, [int]$Block, [int]$Part, $ManifestAudio) {
  $firstPage = (($Block - 1) * 10 + ($Part - 1)) * 2 + 1
  $secondPage = $firstPage + 1
  $overview = @(Read-SlideTexts $Zip $firstPage)
  $detail = @(Read-SlideTexts $Zip $secondPage)
  $objectiveIndex = Index-OfText $detail 'Objetivo técnico'
  $applicationIndex = Index-OfText $detail 'Aplicación en explotación'
  $evidenceIndex = -1
  for ($index = 0; $index -lt $detail.Count; $index += 1) {
    if ($detail[$index] -like 'Evidencia:*') { $evidenceIndex = $index; break }
  }
  if ($objectiveIndex -lt 0 -or $applicationIndex -le $objectiveIndex) {
    throw "$($Deck.Filename), parte $Block.${Part}: no se encontró el contenido técnico."
  }

  $bullets = @()
  for ($index = $objectiveIndex + 1; $index -lt $applicationIndex; $index += 1) {
    $value = Normalize-Text ($detail[$index] -replace '^[•·\-]\s*', '')
    if ($value) { $bullets += $value }
  }
  $applicationEnd = if ($evidenceIndex -gt $applicationIndex) { $evidenceIndex } else { $detail.Count }
  $applicationParts = @()
  for ($index = $applicationIndex + 1; $index -lt $applicationEnd; $index += 1) {
    if ($detail[$index] -notmatch '^\d{2,3}/100$') { $applicationParts += $detail[$index] }
  }
  $application = Normalize-Text ($applicationParts -join ' ')
  $evidence = if ($evidenceIndex -ge 0) { Normalize-Text $detail[$evidenceIndex] } else { '' }
  $control = Normalize-Text (($overview | Where-Object { $_ -like 'Punto de control:*' } | Select-Object -First 1) -replace '^Punto de control:\s*', '')
  if (-not $control) { $control = 'Detener la tarea y comunicar cualquier condición que impida trabajar con seguridad.' }

  $summary = Normalize-Text ($bullets -join ' ')
  $keyPoints = @($bullets)
  if ($application) { $keyPoints += "Aplicación práctica: $application" }
  $sourceLabel = $Deck.SourceLabel
  $sourcePages = "Diapositivas $firstPage–$secondPage"
  $narration = Normalize-Text "$summary Aplicación práctica: $application"

  if ($ManifestAudio) {
    $summary = Normalize-Text $ManifestAudio.explanation
    $keyPoints = @($ManifestAudio.keyPoints | ForEach-Object { Normalize-Text $_ })
    $control = Normalize-Text $ManifestAudio.stopCriterion
    $sourceLabel = Normalize-Text $ManifestAudio.source
    $sourcePages = Normalize-Text $ManifestAudio.pdfPages
    $narration = Normalize-Text $ManifestAudio.explanation
  }

  if ($summary.Length -lt 10 -or $narration.Length -lt 10 -or $keyPoints.Count -lt 2) {
    throw "$($Deck.Filename), parte $Block.${Part}: detalle didáctico insuficiente."
  }

  $overviewBody = Normalize-Text ((@($overview | Where-Object {
    $_ -notmatch '^Parte\s+\d+\.\d+$' -and
    $_ -notmatch '^\d{2,3}/100$' -and
    $_ -notlike 'INMÍNERCAMPUS*'
  }) | Select-Object -Last 2) -join ' ')
  $detailBody = Normalize-Text "$summary Aplicación en explotación: $application $evidence"

  return @{
    Summary = $summary
    KeyPoints = $keyPoints
    StopCriterion = $control
    SourceLabel = $sourceLabel
    SourcePages = $sourcePages
    Narration = $narration
    OverviewBody = $overviewBody
    DetailBody = $detailBody
  }
}

$manifest = Get-Content -Raw -Encoding UTF8 -LiteralPath $courseTwoManifestPath | ConvertFrom-Json
$rows = [Collections.Generic.List[string]]::new()
$batches = [Collections.Generic.List[object]]::new()

foreach ($deck in $decks) {
  $source = Join-Path $deckRoot $deck.Filename
  if (-not (Test-Path -LiteralPath $source)) { throw "No se encontró $source" }
  $zip = [IO.Compression.ZipFile]::OpenRead($source)
  try {
    for ($block = 1; $block -le 5; $block += 1) {
      $batchRows = [Collections.Generic.List[string]]::new()
      for ($part = 1; $part -le 10; $part += 1) {
        $manifestAudio = if ($deck.Manifest) {
          $manifest.audios | Where-Object { $_.block -eq $block -and $_.position -eq $part } | Select-Object -First 1
        } else { $null }
        $detail = Build-DeckDetail $deck $zip $block $part $manifestAudio
        $keyPointSql = ($detail.KeyPoints | ForEach-Object { Sql-Literal $_ }) -join ', '
        $row = (
          '  ({0}, {1}, {2}, {3}, {4}, array[{5}]::text[], {6}, {7}, {8}, {9}, {10}, {11})' -f
            (Sql-Literal $deck.Slug),
            $deck.DurationHours,
            $block,
            $part,
            (Sql-Literal $detail.Summary),
            $keyPointSql,
            (Sql-Literal $detail.StopCriterion),
            (Sql-Literal $detail.SourceLabel),
            (Sql-Literal $detail.SourcePages),
            (Sql-Literal $detail.Narration),
            (Sql-Literal $detail.OverviewBody),
            (Sql-Literal $detail.DetailBody)
        )
        $null = $rows.Add($row)
        $null = $batchRows.Add($row)
      }
      $null = $batches.Add(@{
        Rows = $batchRows
        Slug = $deck.Slug
        DurationHours = $deck.DurationHours
        Block = $block
      })
    }
  } finally { $zip.Dispose() }
}

if ($rows.Count -ne 200) { throw "Se esperaban 200 detalles y se generaron $($rows.Count)." }
if ($batches.Count -ne 20) { throw "Se esperaban 20 lotes y se generaron $($batches.Count)." }

$migrationFile = Get-Item -LiteralPath $MigrationPath
$baseVersion = [Int64]([IO.Path]::GetFileNameWithoutExtension($migrationFile.Name).Split('_')[0])
$migrationDirectory = $migrationFile.DirectoryName

for ($batchIndex = 0; $batchIndex -lt $batches.Count; $batchIndex += 1) {
  $batch = $batches[$batchIndex]
  $valuesSql = $batch.Rows -join ",`r`n"
  $sequence = $batchIndex + 1
  $version = $baseVersion + $batchIndex
  $outputPath = Join-Path $migrationDirectory ("{0}_publish_audio_and_course_details_{1:d2}.sql" -f $version, $sequence)
  $sql = @"
-- Corrige la reproducción privada de los cursos con audio y publica la
-- información didáctica detallada del lote $sequence/20 a partir de sus fuentes.

begin;

create temporary table course_part_details (
  slug text not null,
  duration_hours integer not null,
  block_position integer not null,
  part_position integer not null,
  summary text not null,
  key_points text[] not null,
  stop_criterion text not null,
  source_label text not null,
  source_pages text not null,
  narration_text text not null,
  overview_body text not null,
  detail_body text not null,
  primary key (slug, duration_hours, block_position, part_position)
) on commit drop;

insert into course_part_details values
$valuesSql;

do `$`$
begin
  if (select count(*) from course_part_details) <> 10 then
    raise exception 'Se esperaban 10 fichas didácticas.';
  end if;
end `$`$;

update public.lesson_audio_segments segment
set narration_text = detail.narration_text,
    published = true,
    updated_at = now()
from public.lessons lesson
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_part_details detail
  on detail.slug = course.slug
 and detail.duration_hours = version.duration_hours
 and detail.block_position = module.position
where segment.lesson_id = lesson.id
  and segment.position = detail.part_position;

update public.lesson_segment_slides slide
set body = case slide.position
      when 1 then detail.overview_body
      else detail.detail_body
    end,
    updated_at = now()
from public.lesson_audio_segments segment
join public.lessons lesson on lesson.id = segment.lesson_id
join public.course_modules module on module.id = lesson.module_id
join public.course_versions version on version.id = module.course_version_id
join public.courses course on course.id = version.course_id
join course_part_details detail
  on detail.slug = course.slug
 and detail.duration_hours = version.duration_hours
 and detail.block_position = module.position
 and detail.part_position = segment.position
where slide.segment_id = segment.id
  and slide.position between 1 and 2;

insert into public.lesson_segment_notes (
  segment_id, summary, key_points, stop_criterion, source_label, source_pages, approved
)
select segment.id, detail.summary, detail.key_points, detail.stop_criterion,
       detail.source_label, detail.source_pages, true
from course_part_details detail
join public.courses course on course.slug = detail.slug
join public.course_versions version
  on version.course_id = course.id
 and version.duration_hours = detail.duration_hours
join public.course_modules module
  on module.course_version_id = version.id
 and module.position = detail.block_position
join public.lessons lesson on lesson.module_id = module.id
join public.lesson_audio_segments segment
  on segment.lesson_id = lesson.id
 and segment.position = detail.part_position
on conflict (segment_id) do update set
  summary = excluded.summary,
  key_points = excluded.key_points,
  stop_criterion = excluded.stop_criterion,
  source_label = excluded.source_label,
  source_pages = excluded.source_pages,
  approved = true,
  updated_at = now();

do `$`$
declare
  detailed_segments integer;
  detailed_slides integer;
  detailed_notes integer;
begin
  select count(*) into detailed_segments
  from course_part_details detail
  join public.courses course on course.slug = detail.slug
  join public.course_versions version on version.course_id = course.id and version.duration_hours = detail.duration_hours
  join public.course_modules module on module.course_version_id = version.id and module.position = detail.block_position
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id and segment.position = detail.part_position
  where segment.published and length(trim(segment.narration_text)) >= 10;

  select count(*) into detailed_slides
  from course_part_details detail
  join public.courses course on course.slug = detail.slug
  join public.course_versions version on version.course_id = course.id and version.duration_hours = detail.duration_hours
  join public.course_modules module on module.course_version_id = version.id and module.position = detail.block_position
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id and segment.position = detail.part_position
  join public.lesson_segment_slides slide on slide.segment_id = segment.id
  where slide.position between 1 and 2 and length(trim(slide.body)) >= 10;

  select count(*) into detailed_notes
  from course_part_details detail
  join public.courses course on course.slug = detail.slug
  join public.course_versions version on version.course_id = course.id and version.duration_hours = detail.duration_hours
  join public.course_modules module on module.course_version_id = version.id and module.position = detail.block_position
  join public.lessons lesson on lesson.module_id = module.id
  join public.lesson_audio_segments segment on segment.lesson_id = lesson.id and segment.position = detail.part_position
  join public.lesson_segment_notes note on note.segment_id = segment.id
  where note.approved;

  if detailed_segments <> 10 or detailed_slides <> 20 or detailed_notes <> 10 then
    raise exception 'Detalle incompleto: % segmentos, % diapositivas y % fichas.',
      detailed_segments, detailed_slides, detailed_notes;
  end if;
end `$`$;

commit;
"@

  Set-Content -LiteralPath $outputPath -Value $sql -Encoding UTF8
  Write-Output "Migración generada: $outputPath"
}

if ($migrationFile.Name -ne ("{0}_publish_audio_and_course_details_01.sql" -f $baseVersion)) {
  Remove-Item -LiteralPath $MigrationPath -ErrorAction SilentlyContinue
}
Write-Output "Fichas didácticas: $($rows.Count)"
