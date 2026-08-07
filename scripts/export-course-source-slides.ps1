param(
  [Parameter(Mandatory = $true)]
  [string]$CoursesPedroRoot,

  [switch]$ForceExport
)

$ErrorActionPreference = 'Stop'

$decks = @(
  @{
    Key = 'arranque'
    FilenamePattern = '^CURSO OPERADOR DE MAQUINARIA DE ARRANQUE-CARGA-VIALES \(reciclaje\)\.pptx$'
    Slides = @(
      4, 5, 6, 7, 8, 9, 10, 11, 12,
      13, 20, 27, 34, 41, 48, 55, 62, 69, 76,
      77, 78, 79, 80, 81, 82, 83, 84,
      85, 86, 87, 88, 89,
      90, 91, 92, 93, 94
    )
  },
  @{
    Key = 'transporte'
    FilenamePattern = '^CURSO OPERADOR DE MAQUINARIA DE TRANSPORTE \(reciclaje\)\.pptx$'
    Slides = @(
      4, 5, 6, 7, 8, 9, 10, 12, 13, 16,
      18, 24, 30, 36, 42, 48, 54, 60, 66, 73,
      74, 75, 76, 77, 78, 79, 80, 81,
      82, 83, 84, 85, 86, 87,
      88, 89, 90, 91, 92, 93, 94, 95
    )
  },
  @{
    Key = 'silice'
    FilenamePattern = '^CURSO FORMACI.N PREVENTIVA PARA POLVO DE S.LICE\.pptx$'
    Slides = @(
      4, 5, 6, 8, 14, 15, 21,
      23, 24, 25, 26, 27, 28,
      29, 30, 31, 32, 33, 34, 35, 36,
      37, 40, 41, 43, 46, 50, 54, 57, 60, 63,
      64, 65, 66, 67, 68, 69, 70, 71, 74, 76
    )
  }
)

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$powerPoint = New-Object -ComObject PowerPoint.Application
$exported = 0
$preserved = 0

try {
  foreach ($deck in $decks) {
    $source = Get-ChildItem -LiteralPath $CoursesPedroRoot -Recurse -File |
      Where-Object { $_.Name -match $deck.FilenamePattern } |
      Sort-Object { $_.FullName.Length } |
      Select-Object -First 1

    if (-not $source) {
      throw "No se ha encontrado $($deck.FilenamePattern) en $CoursesPedroRoot"
    }

    $destination = Join-Path $repositoryRoot "public\course-slides\sources\$($deck.Key)"
    New-Item -ItemType Directory -Path $destination -Force | Out-Null

    $presentation = $powerPoint.Presentations.Open(
      $source.FullName,
      $true,
      $true,
      $false
    )

    try {
      foreach ($slideNumber in ($deck.Slides | Sort-Object -Unique)) {
        if ($slideNumber -gt $presentation.Slides.Count) {
          throw "La diapositiva $slideNumber no existe en $($source.FullName)"
        }

        $filename = 'source-slide-{0:D3}.jpg' -f $slideNumber
        $target = Join-Path $destination $filename
        if ((Test-Path -LiteralPath $target) -and -not $ForceExport) {
          $preserved += 1
          continue
        }

        $presentation.Slides.Item($slideNumber).Export(
          $target,
          'JPG',
          1600,
          900
        )
        $exported += 1
      }
    } finally {
      $presentation.Close()
      [System.Runtime.InteropServices.Marshal]::ReleaseComObject(
        $presentation
      ) | Out-Null
    }
  }
} finally {
  $powerPoint.Quit()
  [System.Runtime.InteropServices.Marshal]::ReleaseComObject(
    $powerPoint
  ) | Out-Null
}

Write-Output "Diapositivas exportadas: $exported"
Write-Output "Diapositivas conservadas: $preserved"
