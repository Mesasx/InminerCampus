param(
  [string]$SourceRoot,
  [string]$OutputRoot,
  [switch]$ForceExport
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
if (-not $SourceRoot) {
  $SourceRoot = Join-Path $repositoryRoot 'Contenido Cursos\Diapositivas y documentos\Diapositivas cursos'
}
if (-not $OutputRoot) {
  $OutputRoot = Join-Path $repositoryRoot '.work\course-slide-decks'
}

$decks = @(
  @{
    Key = 'course-4'
    Filename = 'Curso_4_Maquinaria_Arranque_Carga_y_Viales_InminerCampus_MEJORADO.pptx'
  },
  @{
    Key = 'course-5'
    Filename = 'Curso_5_Transporte_Camion_y_Volquete_InminerCampus_FOTOS_GENERADAS.pptx'
  },
  @{
    Key = 'course-6'
    Filename = 'Curso_6_Polvo_y_Silice_20H_InminerCampus_VARIADO_ALTA_CALIDAD (1).pptx'
  }
)

$powerPoint = New-Object -ComObject PowerPoint.Application
$exported = 0
$preserved = 0

try {
  foreach ($deck in $decks) {
    $source = Join-Path $SourceRoot $deck.Filename
    if (-not (Test-Path -LiteralPath $source)) {
      throw "No se ha encontrado la presentación: $source"
    }

    $destination = Join-Path $OutputRoot $deck.Key
    New-Item -ItemType Directory -Path $destination -Force | Out-Null

    $presentation = $powerPoint.Presentations.Open($source, $true, $true, $false)
    try {
      if ($presentation.Slides.Count -ne 100) {
        throw "$($deck.Filename) contiene $($presentation.Slides.Count) diapositivas; se esperaban 100."
      }

      for ($slideNumber = 1; $slideNumber -le 100; $slideNumber += 1) {
        $filename = 'slide-{0:D3}.jpg' -f $slideNumber
        $target = Join-Path $destination $filename
        if ((Test-Path -LiteralPath $target) -and -not $ForceExport) {
          $preserved += 1
          continue
        }

        $presentation.Slides.Item($slideNumber).Export($target, 'JPG', 1600, 900)
        $exported += 1
      }
    } finally {
      $presentation.Close()
      [System.Runtime.InteropServices.Marshal]::ReleaseComObject($presentation) | Out-Null
    }
  }
} finally {
  $powerPoint.Quit()
  [System.Runtime.InteropServices.Marshal]::ReleaseComObject($powerPoint) | Out-Null
}

Write-Output "Diapositivas exportadas: $exported"
Write-Output "Diapositivas conservadas: $preserved"
