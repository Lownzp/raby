param(
  [string]$ApkPath = 'dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk',
  [string]$Sha256Path = 'dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk.sha256',
  [string]$BundlePath = 'dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip',
  [string]$BundleSha256Path = 'dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip.sha256',
  [string]$ScreenshotDir = 'docs\prototypes\screenshots',
  [string]$HandoffPath = 'docs\prototypes\raby-v0.1.0-acceptance-handoff.md',
  [string]$RequirementAuditPath = 'docs\prototypes\raby-v0.1.0-requirement-audit.md',
  [string]$ManifestPath = 'docs\prototypes\raby-v0.1.0-acceptance-manifest.json',
  [int]$ExpectedTestCount = 48
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$failures = New-Object System.Collections.Generic.List[string]
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Drawing
$expectedTestSummary = '{0}/{0} passed' -f $ExpectedTestCount
$expectedTestSummaryPattern = [regex]::Escape($expectedTestSummary)

function Resolve-RepoPath {
  param([Parameter(Mandatory = $true)][string]$Path)
  return Join-Path $repoRoot $Path
}

function Test-RequiredFile {
  param(
    [Parameter(Mandatory = $true)][string]$Label,
    [Parameter(Mandatory = $true)][string]$Path
  )

  $resolved = Resolve-RepoPath $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    $failures.Add("$Label missing: $resolved")
    return $null
  }
  $file = Get-Item -LiteralPath $resolved
  if ($file.Length -le 0) {
    $failures.Add("$Label is empty: $resolved")
  }
  return $file
}

function Test-PngQuality {
  param(
    [Parameter(Mandatory = $true)][string]$Label,
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][int]$ExpectedWidth,
    [Parameter(Mandatory = $true)][int]$ExpectedHeight,
    [Parameter(Mandatory = $true)][int]$MinimumBytes
  )

  $resolved = Resolve-RepoPath $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    $failures.Add("$Label missing: $resolved")
    return
  }
  $file = Get-Item -LiteralPath $resolved
  if ($file.Length -lt $MinimumBytes) {
    $failures.Add("$Label is unexpectedly small: $($file.Length) bytes")
  }

  $bitmap = [System.Drawing.Bitmap]::FromFile($file.FullName)
  try {
    if ($bitmap.Width -ne $ExpectedWidth -or $bitmap.Height -ne $ExpectedHeight) {
      $failures.Add("$Label dimensions mismatch: $($bitmap.Width)x$($bitmap.Height)")
    }

    $minR = 255
    $minG = 255
    $minB = 255
    $maxR = 0
    $maxG = 0
    $maxB = 0
    $stepX = [Math]::Max(1, [int]($bitmap.Width / 40))
    $stepY = [Math]::Max(1, [int]($bitmap.Height / 40))
    for ($y = 0; $y -lt $bitmap.Height; $y += $stepY) {
      for ($x = 0; $x -lt $bitmap.Width; $x += $stepX) {
        $color = $bitmap.GetPixel($x, $y)
        if ($color.R -lt $minR) { $minR = $color.R }
        if ($color.G -lt $minG) { $minG = $color.G }
        if ($color.B -lt $minB) { $minB = $color.B }
        if ($color.R -gt $maxR) { $maxR = $color.R }
        if ($color.G -gt $maxG) { $maxG = $color.G }
        if ($color.B -gt $maxB) { $maxB = $color.B }
      }
    }
    $rgbRange = ($maxR - $minR) + ($maxG - $minG) + ($maxB - $minB)
    if ($rgbRange -lt 30) {
      $failures.Add("$Label appears blank or nearly flat: rgbRange=$rgbRange")
    }
  } finally {
    $bitmap.Dispose()
  }
}

$apk = Test-RequiredFile -Label 'APK' -Path $ApkPath
$sha = Test-RequiredFile -Label 'SHA256 file' -Path $Sha256Path
$bundle = Test-RequiredFile -Label 'Acceptance bundle' -Path $BundlePath
$bundleSha = Test-RequiredFile -Label 'Acceptance bundle SHA256 file' -Path $BundleSha256Path
$handoff = Test-RequiredFile -Label 'Acceptance handoff' -Path $HandoffPath
$requirementAudit = Test-RequiredFile -Label 'Requirement audit' -Path $RequirementAuditPath
$manifestFile = Test-RequiredFile -Label 'Acceptance manifest' -Path $ManifestPath
$contactSheetPath = Join-Path $ScreenshotDir 'raby-contact-sheet.png'
$contactSheet = Test-RequiredFile `
  -Label 'Screenshot contact sheet' `
  -Path $contactSheetPath
$photoCreditsPath = 'tooling\screenshot_harness\assets\PHOTO_CREDITS.md'
$photoCredits = Test-RequiredFile `
  -Label 'Screenshot sample photo credits' `
  -Path $photoCreditsPath
$adbSmokeScreenshotPath = Join-Path $ScreenshotDir 'raby-adb-install-smoke.png'
$adbSmokeScreenshot = Test-RequiredFile `
  -Label 'ADB install smoke screenshot' `
  -Path $adbSmokeScreenshotPath

$requiredScreenshots = @(
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

if ($apk -and $sha) {
  $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $apk.FullName).Hash
  $recordedHash = ((Get-Content -LiteralPath $sha.FullName -Raw) -split '\s+')[0]
  if ($actualHash -ne $recordedHash) {
    $failures.Add("APK SHA256 mismatch: actual=$actualHash recorded=$recordedHash")
  }

  $localPropertiesPath = Resolve-RepoPath 'android\local.properties'
  $sdkDirLine = Get-Content -LiteralPath $localPropertiesPath |
    Where-Object { $_ -like 'sdk.dir=*' } |
    Select-Object -First 1
  if ($sdkDirLine) {
    $sdkDir = ($sdkDirLine -replace '^sdk\.dir=', '') -replace '\\\\', '\'
    $aapt = Get-ChildItem -LiteralPath (Join-Path $sdkDir 'build-tools') `
      -Recurse `
      -Filter 'aapt.exe' |
      Sort-Object FullName -Descending |
      Select-Object -First 1
    if ($aapt) {
      $badging = (& $aapt.FullName dump badging $apk.FullName) -join "`n"
      if ($badging -notmatch "package: name='com\.raby\.raby'.*versionCode='2001'.*versionName='0\.1\.0'") {
        $failures.Add('APK badging package/version does not match com.raby.raby 0.1.0/2001')
      }
      if ($badging -notmatch "application-label:'Raby'") {
        $failures.Add('APK application label is not Raby')
      }
      if ($badging -notmatch "native-code: 'arm64-v8a'" -or
          $badging -match "native-code: .*'armeabi-v7a'" -or
          $badging -match "native-code: .*'x86_64'") {
        $failures.Add('APK native-code is not arm64-v8a only')
      }
      $apksigner = Join-Path (Split-Path $aapt.FullName) 'apksigner.bat'
      if (Test-Path -LiteralPath $apksigner) {
        $certs = (& $apksigner verify --print-certs $apk.FullName) -join "`n"
        if ($LASTEXITCODE -ne 0) {
          $failures.Add('APK signature verification failed')
        }
        if ($certs -notmatch 'Signer #1 certificate DN: C=US, O=Android, CN=Android Debug') {
          $failures.Add('APK signer is not the documented Android Debug acceptance certificate')
        }
      } else {
        $failures.Add("apksigner.bat not found next to aapt.exe: $apksigner")
      }
    } else {
      $failures.Add("aapt.exe not found under Android SDK: $sdkDir")
    }
  } else {
    $failures.Add('android/local.properties does not contain sdk.dir')
  }
}

if ($bundle -and $bundleSha) {
  $actualBundleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bundle.FullName).Hash
  $recordedBundleHash = ((Get-Content -LiteralPath $bundleSha.FullName -Raw) -split '\s+')[0]
  if ($actualBundleHash -ne $recordedBundleHash) {
    $failures.Add("Acceptance bundle SHA256 mismatch: actual=$actualBundleHash recorded=$recordedBundleHash")
  }
  $bundleEntries = [System.IO.Compression.ZipFile]::OpenRead($bundle.FullName)
  $bundleAuditTemp = Join-Path $env:TEMP (
    'raby-bundle-audit-' + [guid]::NewGuid().ToString('N')
  )
  New-Item -ItemType Directory -Path $bundleAuditTemp | Out-Null
  try {
    $requiredBundleEntries = @(
      'README.md',
      'raby-v0.1.0-acceptance-handoff.md',
      'raby-v0.1.0-requirement-audit.md',
      'raby-v0.1.0-acceptance-manifest.json',
      'raby-contact-sheet.png',
      'PHOTO_CREDITS.md',
      'raby-adb-install-smoke.png',
      'tooling/create-acceptance-bundle.ps1',
      'tooling/verify-acceptance-artifacts.ps1',
      'tooling/publish-public-apk.ps1',
      (Split-Path -Leaf $ApkPath),
      (Split-Path -Leaf $Sha256Path)
    )
    foreach ($screenshot in $requiredScreenshots) {
      $requiredBundleEntries += "screenshots/$screenshot"
    }
    $entriesByName = @{}
    foreach ($zipEntry in $bundleEntries.Entries) {
      $entriesByName[$zipEntry.FullName -replace '\\', '/'] = $zipEntry
    }
    $entryNames = @($entriesByName.Keys)
    foreach ($entry in $requiredBundleEntries) {
      if ($entryNames -notcontains $entry) {
        $failures.Add("Acceptance bundle missing entry: $entry")
      }
    }

    $bundleEntryLocalPaths = @{
      'README.md' = 'README.md'
      'raby-v0.1.0-acceptance-handoff.md' = $HandoffPath
      'raby-v0.1.0-requirement-audit.md' = $RequirementAuditPath
      'raby-v0.1.0-acceptance-manifest.json' = $ManifestPath
      'raby-contact-sheet.png' = (Join-Path $ScreenshotDir 'raby-contact-sheet.png')
      'PHOTO_CREDITS.md' = $photoCreditsPath
      'raby-adb-install-smoke.png' = $adbSmokeScreenshotPath
      'tooling/create-acceptance-bundle.ps1' = 'tooling\create-acceptance-bundle.ps1'
      'tooling/verify-acceptance-artifacts.ps1' = 'tooling\verify-acceptance-artifacts.ps1'
      'tooling/publish-public-apk.ps1' = 'tooling\publish-public-apk.ps1'
      (Split-Path -Leaf $ApkPath) = $ApkPath
      (Split-Path -Leaf $Sha256Path) = $Sha256Path
    }
    foreach ($screenshot in $requiredScreenshots) {
      $bundleEntryLocalPaths["screenshots/$screenshot"] =
        (Join-Path $ScreenshotDir $screenshot)
    }

    foreach ($entryName in $bundleEntryLocalPaths.Keys) {
      $entry = $entriesByName[$entryName]
      if (-not $entry) {
        continue
      }
      $extractedPath = Join-Path $bundleAuditTemp (
        $entryName -replace '/', [IO.Path]::DirectorySeparatorChar
      )
      New-Item -ItemType Directory -Force -Path (Split-Path $extractedPath) |
        Out-Null
      [System.IO.Compression.ZipFileExtensions]::ExtractToFile(
        $entry,
        $extractedPath,
        $true
      )
      $localPath = Resolve-RepoPath $bundleEntryLocalPaths[$entryName]
      $entryHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $extractedPath).Hash
      $localHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $localPath).Hash
      if ($entryHash -ne $localHash) {
        $failures.Add("Acceptance bundle entry is stale: $entryName")
      }
    }
  } finally {
    $bundleEntries.Dispose()
    Remove-Item -LiteralPath $bundleAuditTemp -Recurse -Force -ErrorAction SilentlyContinue
  }
}

if ($manifestFile) {
  $manifest = Get-Content -LiteralPath $manifestFile.FullName -Raw | ConvertFrom-Json
  if ($manifest.version.pubspec -ne '0.1.0+1') {
    $failures.Add("Manifest pubspec version is not 0.1.0+1")
  }
  if ($manifest.version.androidVersionName -ne '0.1.0') {
    $failures.Add("Manifest androidVersionName is not 0.1.0")
  }
  if ([int]$manifest.version.androidVersionCode -ne 2001) {
    $failures.Add("Manifest androidVersionCode is not 2001")
  }
  if ($manifest.artifacts.apk.path -ne $ApkPath) {
    $failures.Add("Manifest APK path mismatch: $($manifest.artifacts.apk.path)")
  }
  if ([int64]$manifest.artifacts.apk.sizeBytes -ne $apk.Length) {
    $failures.Add("Manifest APK size mismatch: $($manifest.artifacts.apk.sizeBytes)")
  }
  if ($manifest.artifacts.apk.sha256 -ne $actualHash) {
    $failures.Add("Manifest APK SHA256 mismatch: $($manifest.artifacts.apk.sha256)")
  }
  if ($manifest.artifacts.acceptanceBundle.path -ne $BundlePath) {
    $failures.Add("Manifest bundle path mismatch: $($manifest.artifacts.acceptanceBundle.path)")
  }
  if ($manifest.artifacts.acceptanceBundle.sha256File -ne $BundleSha256Path) {
    $failures.Add("Manifest bundle SHA256 file mismatch: $($manifest.artifacts.acceptanceBundle.sha256File)")
  }
  if ($manifest.artifacts.requirementAudit -ne $RequirementAuditPath) {
    $failures.Add("Manifest requirement audit path mismatch: $($manifest.artifacts.requirementAudit)")
  }
  if ($manifest.artifacts.adbInstallSmokeScreenshot -ne $adbSmokeScreenshotPath) {
    $failures.Add("Manifest ADB smoke screenshot path mismatch: $($manifest.artifacts.adbInstallSmokeScreenshot)")
  }
  if ($manifest.artifacts.samplePhotoCredits -ne $photoCreditsPath) {
    $failures.Add("Manifest sample photo credits path mismatch: $($manifest.artifacts.samplePhotoCredits)")
  }
  if ($manifest.verification.analyze -ne 'passed') {
    $failures.Add("Manifest analyze status is not passed: $($manifest.verification.analyze)")
  }
  if ($manifest.verification.tests.status -ne 'passed') {
    $failures.Add("Manifest test status is not passed: $($manifest.verification.tests.status)")
  }
  if ([int]$manifest.verification.tests.count -ne $ExpectedTestCount) {
    $failures.Add("Manifest test count mismatch: $($manifest.verification.tests.count)")
  }
  if ($manifest.verification.releaseBuild -ne 'passed') {
    $failures.Add("Manifest releaseBuild status is not passed: $($manifest.verification.releaseBuild)")
  }
  if ($manifest.verification.acceptanceArtifactCheck -ne 'passed') {
    $failures.Add("Manifest acceptanceArtifactCheck status is not passed: $($manifest.verification.acceptanceArtifactCheck)")
  }
  if ([int]$manifest.screenshots.count -ne $requiredScreenshots.Count) {
    $failures.Add("Manifest screenshot count mismatch: $($manifest.screenshots.count)")
  }
  $manifestPages = @($manifest.screenshots.pages)
  $missingManifestPages = $requiredScreenshots |
    Where-Object { $manifestPages -notcontains $_ }
  if ($missingManifestPages.Count -gt 0) {
    $failures.Add("Manifest missing screenshot pages: $($missingManifestPages -join ', ')")
  }
}

foreach ($screenshot in $requiredScreenshots) {
  Test-RequiredFile `
    -Label "Screenshot $screenshot" `
    -Path (Join-Path $ScreenshotDir $screenshot) | Out-Null
  Test-PngQuality `
    -Label "Screenshot $screenshot" `
    -Path (Join-Path $ScreenshotDir $screenshot) `
    -ExpectedWidth 430 `
    -ExpectedHeight 932 `
    -MinimumBytes 10000
}

Test-PngQuality `
  -Label 'Screenshot contact sheet' `
  -Path $contactSheetPath `
  -ExpectedWidth 940 `
  -ExpectedHeight 2056 `
  -MinimumBytes 100000

Test-PngQuality `
  -Label 'ADB install smoke screenshot' `
  -Path $adbSmokeScreenshotPath `
  -ExpectedWidth 1080 `
  -ExpectedHeight 2400 `
  -MinimumBytes 10000

$pubspec = Get-Content -LiteralPath (Resolve-RepoPath 'pubspec.yaml') -Raw
$localProperties = Get-Content -LiteralPath (Resolve-RepoPath 'android\local.properties') -Raw
$settingsPage = Get-Content -LiteralPath (Resolve-RepoPath 'lib\features\settings\presentation\settings_page.dart') -Raw
$readme = Get-Content -LiteralPath (Resolve-RepoPath 'README.md') -Raw
$resolvedHandoffPath = Resolve-RepoPath $HandoffPath
$resolvedRequirementAuditPath = Resolve-RepoPath $RequirementAuditPath
$handoffText = if (Test-Path -LiteralPath $resolvedHandoffPath) {
  [string](Get-Content -LiteralPath $resolvedHandoffPath -Raw)
} else {
  ''
}
$requirementAuditText = if (Test-Path -LiteralPath $resolvedRequirementAuditPath) {
  [string](Get-Content -LiteralPath $resolvedRequirementAuditPath -Raw)
} else {
  ''
}

if ($pubspec -notmatch '(?m)^version:\s*0\.1\.0\+1\s*$') {
  $failures.Add('pubspec.yaml version is not 0.1.0+1')
}
if ($localProperties -notmatch '(?m)^flutter\.versionName=0\.1\.0\s*$') {
  $failures.Add('android/local.properties flutter.versionName is not 0.1.0')
}
if ($localProperties -notmatch '(?m)^flutter\.versionCode=1\s*$') {
  $failures.Add('android/local.properties flutter.versionCode is not 1')
}
if ($settingsPage -notmatch 'v0\.1\.0') {
  $failures.Add('Settings page does not mention v0.1.0')
}
if ($readme -notmatch [regex]::Escape($ApkPath)) {
  $failures.Add("README.md does not reference $ApkPath")
}
if ($readme -notmatch [regex]::Escape($Sha256Path)) {
  $failures.Add("README.md does not reference $Sha256Path")
}
if ($readme -notmatch [regex]::Escape($BundlePath)) {
  $failures.Add("README.md does not reference $BundlePath")
}
if ($readme -notmatch [regex]::Escape($BundleSha256Path)) {
  $failures.Add("README.md does not reference $BundleSha256Path")
}
if ($readme -notmatch [regex]::Escape($RequirementAuditPath)) {
  $failures.Add("README.md does not reference $RequirementAuditPath")
}
if ($handoffText -notmatch [regex]::Escape($ApkPath)) {
  $failures.Add("Handoff does not reference $ApkPath")
}
if ($handoffText -notmatch [regex]::Escape($actualHash)) {
  $failures.Add('Handoff does not reference current APK SHA256')
}
if (-not (Select-String -LiteralPath $resolvedHandoffPath -SimpleMatch $expectedTestSummary -Quiet)) {
  $failures.Add("Handoff does not reference $expectedTestSummary")
}
if ($handoffText -notmatch [regex]::Escape($RequirementAuditPath)) {
  $failures.Add("Handoff does not reference $RequirementAuditPath")
}
if ($requirementAuditText -notmatch [regex]::Escape($actualHash)) {
  $failures.Add('Requirement audit does not reference current APK SHA256')
}
if (-not (Select-String -LiteralPath $resolvedRequirementAuditPath -SimpleMatch $expectedTestSummary -Quiet)) {
  $failures.Add("Requirement audit does not reference $expectedTestSummary")
}

if ($failures.Count -gt 0) {
  Write-Host 'Acceptance artifact verification failed:'
  foreach ($failure in $failures) {
    Write-Host " - $failure"
  }
  exit 1
}

Write-Host 'Acceptance artifact verification passed.'
Write-Host "APK: $($apk.FullName)"
Write-Host "APK size: $($apk.Length) bytes"
Write-Host "SHA256: $actualHash"
Write-Host "Bundle: $($bundle.FullName)"
Write-Host "Bundle size: $($bundle.Length) bytes"
Write-Host "Bundle SHA256: $actualBundleHash"
Write-Host "Screenshots checked: $($requiredScreenshots.Count) + contact sheet"
Write-Host "Handoff: $($handoff.FullName)"
Write-Host "Requirement audit: $($requirementAudit.FullName)"
Write-Host "Manifest: $($manifestFile.FullName)"


