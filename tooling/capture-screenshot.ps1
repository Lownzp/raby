param(
  [ValidateSet('home', 'home-empty', 'search', 'album', 'photo-viewer', 'weight', 'weight-empty', 'weight-edit', 'diary-edit', 'diary-detail', 'profile', 'settings', 'onboarding', 'rabbit-detail')]
  [string]$Page = 'home',

  [int]$Width = 430,
  [int]$Height = 932,
  [double]$PixelRatio = 2,
  [string]$OutputDir = 'docs\prototypes\screenshots',
  [int]$TimeoutSec = 120
)

$ErrorActionPreference = 'Stop'
$mutex = [System.Threading.Mutex]::new($false, 'Global\RabyScreenshotHarnessLock')
$lockTaken = $false
$oldEnv = $null

try {
  $lockTaken = $mutex.WaitOne([TimeSpan]::FromMinutes(5))
  if (-not $lockTaken) {
    throw 'Timed out waiting for screenshot harness lock.'
  }
} catch {
  $mutex.Dispose()
  throw
}

try {
function Stop-RabyScreenshotChildren {
  param([DateTime]$Since)

  $names = @('flutter_tester', 'dart', 'dartvm', 'dartaotruntime')
  Get-Process -ErrorAction SilentlyContinue |
    Where-Object {
      $names -contains $_.ProcessName -and
      $_.StartTime -ge $Since.AddSeconds(-2)
    } |
    ForEach-Object {
      Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$harness = Join-Path $repoRoot 'tooling\screenshot_harness\raby_screenshot_test.dart'
$outputRoot = Join-Path $repoRoot $OutputDir
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
$outputPath = Join-Path $outputRoot "raby-$Page.png"
if (Test-Path -LiteralPath $outputPath) {
  Remove-Item -LiteralPath $outputPath -Force
}

$localProperties = Join-Path $repoRoot 'android\local.properties'
$flutterSdk = 'D:\work\toolchains\flutter'
if (Test-Path -LiteralPath $localProperties) {
  $sdkLine = Get-Content -LiteralPath $localProperties |
    Where-Object { $_ -like 'flutter.sdk=*' } |
    Select-Object -First 1
  if ($sdkLine) {
    $flutterSdk = ($sdkLine -replace '^flutter\.sdk=', '') -replace '\\\\', '\'
  }
}
$flutter = Join-Path $flutterSdk 'bin\flutter.bat'
if (-not (Test-Path -LiteralPath $flutter)) {
  throw "Flutter SDK not found: $flutter"
}

$startedAt = Get-Date
$stdout = Join-Path $env:TEMP "raby-screenshot-$Page.out.log"
$stderr = Join-Path $env:TEMP "raby-screenshot-$Page.err.log"
Remove-Item -LiteralPath $stdout, $stderr -Force -ErrorAction SilentlyContinue

$oldEnv = @{
  RABY_SCREENSHOT_WIDTH = $env:RABY_SCREENSHOT_WIDTH
  RABY_SCREENSHOT_HEIGHT = $env:RABY_SCREENSHOT_HEIGHT
  RABY_SCREENSHOT_PIXEL_RATIO = $env:RABY_SCREENSHOT_PIXEL_RATIO
  RABY_SCREENSHOT_OUTPUT = $env:RABY_SCREENSHOT_OUTPUT
}

$env:RABY_SCREENSHOT_WIDTH = "$Width"
$env:RABY_SCREENSHOT_HEIGHT = "$Height"
$env:RABY_SCREENSHOT_PIXEL_RATIO = "$PixelRatio"
$env:RABY_SCREENSHOT_OUTPUT = $outputPath

try {
  $args = "test --plain-name `"capture $Page`" `"$harness`""
  $process = Start-Process `
    -FilePath $flutter `
    -ArgumentList $args `
    -WorkingDirectory $repoRoot `
    -RedirectStandardOutput $stdout `
    -RedirectStandardError $stderr `
    -WindowStyle Hidden `
    -PassThru

  $deadline = (Get-Date).AddSeconds($TimeoutSec)
  $screenshotReadyAt = $null
  $killedAfterScreenshot = $false

  while (-not $process.HasExited -and (Get-Date) -lt $deadline) {
    Start-Sleep -Milliseconds 500
    if (-not $screenshotReadyAt -and (Test-Path -LiteralPath $outputPath)) {
      $file = Get-Item -LiteralPath $outputPath
      if ($file.Length -gt 0 -and $file.LastWriteTime -ge $startedAt.AddSeconds(-1)) {
        $screenshotReadyAt = Get-Date
      }
    }
    if ($screenshotReadyAt -and ((Get-Date) - $screenshotReadyAt).TotalSeconds -ge 2) {
      Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
      $killedAfterScreenshot = $true
      break
    }
  }

  if (-not $process.HasExited -and -not $killedAfterScreenshot) {
    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
    Stop-RabyScreenshotChildren -Since $startedAt
    throw "Screenshot timed out before output was created: $Page"
  }

  Stop-RabyScreenshotChildren -Since $startedAt

  if (-not (Test-Path -LiteralPath $outputPath)) {
    $out = Get-Content -LiteralPath $stdout -Raw -ErrorAction SilentlyContinue
    $err = Get-Content -LiteralPath $stderr -Raw -ErrorAction SilentlyContinue
    throw "Screenshot output was not created.`n$out`n$err"
  }

  $output = Get-Item -LiteralPath $outputPath
  if ($output.Length -le 0) {
    throw "Screenshot output is empty: $outputPath"
  }

  Write-Host "Screenshot saved: $($output.FullName)"
  Write-Host "Viewport: ${Width}x${Height} @ ${PixelRatio}x"
  Write-Host "File size: $($output.Length) bytes"
} finally {
  if ($null -ne $oldEnv) {
    foreach ($key in $oldEnv.Keys) {
      if ($null -eq $oldEnv[$key]) {
        Remove-Item "Env:$key" -ErrorAction SilentlyContinue
      } else {
        Set-Item "Env:$key" $oldEnv[$key]
      }
    }
  }
}
} finally {
  if ($lockTaken) {
    $mutex.ReleaseMutex()
  }
  $mutex.Dispose()
}
