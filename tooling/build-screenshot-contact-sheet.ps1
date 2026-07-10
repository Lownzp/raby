param(
  [string]$ScreenshotDir = 'docs\prototypes\screenshots',
  [string]$Output = 'docs\prototypes\screenshots\raby-contact-sheet.png',
  [int]$Columns = 4,
  [int]$ThumbWidth = 215,
  [int]$ThumbHeight = 466,
  [int]$Gap = 16
)

$ErrorActionPreference = 'Stop'

$pages = @(
  'raby-home.png',
  'raby-home-empty.png',
  'raby-weight.png',
  'raby-weight-empty.png',
  'raby-weight-edit.png',
  'raby-diary-edit.png',
  'raby-diary-detail.png',
  'raby-search.png',
  'raby-album.png',
  'raby-photo-viewer.png',
  'raby-profile.png',
  'raby-settings.png',
  'raby-onboarding.png',
  'raby-rabbit-detail.png'
)

Add-Type -AssemblyName System.Drawing

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$inputRoot = Join-Path $repoRoot $ScreenshotDir
$outputPath = Join-Path $repoRoot $Output
$labelHeight = 28
$rows = [Math]::Ceiling($pages.Count / $Columns)
$sheetWidth = ($Columns * $ThumbWidth) + (($Columns + 1) * $Gap)
$sheetHeight = ($rows * ($ThumbHeight + $labelHeight)) + (($rows + 1) * $Gap)

$bitmap = [System.Drawing.Bitmap]::new($sheetWidth, $sheetHeight)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$font = [System.Drawing.Font]::new('Arial', 9)
$brush = [System.Drawing.SolidBrush]::new(
  [System.Drawing.Color]::FromArgb(255, 90, 42, 22)
)

try {
  $graphics.Clear([System.Drawing.Color]::FromArgb(255, 255, 250, 239))
  $graphics.InterpolationMode =
    [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

  for ($i = 0; $i -lt $pages.Count; $i++) {
    $page = $pages[$i]
    $source = Join-Path $inputRoot $page
    if (-not (Test-Path -LiteralPath $source)) {
      throw "Screenshot not found: $source"
    }

    $column = $i % $Columns
    $row = [Math]::Floor($i / $Columns)
    $x = $Gap + ($column * ($ThumbWidth + $Gap))
    $y = $Gap + ($row * ($ThumbHeight + $labelHeight + $Gap))

    $image = [System.Drawing.Image]::FromFile($source)
    try {
      $graphics.DrawImage($image, $x, $y, $ThumbWidth, $ThumbHeight)
    } finally {
      $image.Dispose()
    }

    $graphics.DrawString(
      $page,
      $font,
      $brush,
      [System.Drawing.PointF]::new($x, $y + $ThumbHeight + 6)
    )
  }

  New-Item -ItemType Directory -Force -Path (Split-Path $outputPath) | Out-Null
  if (Test-Path -LiteralPath $outputPath) {
    Remove-Item -LiteralPath $outputPath -Force
  }
  $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $file = Get-Item -LiteralPath $outputPath
  Write-Host "Contact sheet saved: $($file.FullName)"
  Write-Host "File size: $($file.Length) bytes"
} finally {
  $brush.Dispose()
  $font.Dispose()
  $graphics.Dispose()
  $bitmap.Dispose()
}
