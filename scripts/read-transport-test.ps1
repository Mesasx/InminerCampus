param(
  [Parameter(Mandatory = $true)]
  [string] $WorkbookPath
)

$resolvedWorkbook = Resolve-Path -LiteralPath $WorkbookPath
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolvedWorkbook)

try {
  $reader = [IO.StreamReader]::new(
    $archive.GetEntry('xl/sharedStrings.xml').Open()
  )
  try { [xml] $sharedXml = $reader.ReadToEnd() }
  finally { $reader.Dispose() }

  $sharedStrings = @(
    $sharedXml.sst.si | ForEach-Object {
      if ($_.t) { [string] $_.t }
      else { ($_.r | ForEach-Object { $_.t }) -join '' }
    }
  )

  $reader = [IO.StreamReader]::new(
    $archive.GetEntry('xl/worksheets/sheet2.xml').Open()
  )
  try { [xml] $sheetXml = $reader.ReadToEnd() }
  finally { $reader.Dispose() }

  $items = foreach ($row in @($sheetXml.worksheet.sheetData.row) | Select-Object -Skip 1) {
    $cells = @{}
    foreach ($cell in @($row.c)) {
      $column = ([regex]::Match([string] $cell.r, '^[A-Z]+')).Value
      $value = if ($cell.t -eq 's') {
        $sharedStrings[[int] $cell.v]
      } elseif ($cell.t -eq 'inlineStr') {
        [string] $cell.is.t
      } else {
        [string] $cell.v
      }
      $cells[$column] = $value
    }

    [pscustomobject] @{
      sourceId = $cells.A
      block = [int] $cells.B
      lessonCode = ([string] $cells.C).Replace('Parte ', '')
      prompt = $cells.D
      options = @($cells.E, $cells.F, $cells.G, $cells.H)
      correct = $cells.I
      explanation = $cells.J
      source = $cells.K
      active = ([string] $cells.L) -match '^S'
    }
  }

  $items | ConvertTo-Json -Depth 4 -Compress
} finally {
  $archive.Dispose()
}
