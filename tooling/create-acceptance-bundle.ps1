param(
  [string]$ApkPath = 'dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk',
  [string]$Sha256Path = 'dist\apk\raby-v0.1.0-arm64-release-20260708-090404.apk.sha256',
  [string]$BundlePath = 'dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip',
  [string]$BundleSha256Path = 'dist\raby-v0.1.0-acceptance-bundle-20260708-0438.zip.sha256',
  [string]$HandoffPath = 'docs\prototypes\raby-v0.1.0-acceptance-handoff.md',
  [string]$RequirementAuditPath = 'docs\prototypes\raby-v0.1.0-requirement-audit.md',
  [string]$ManifestPath = 'docs\prototypes\raby-v0.1.0-acceptance-manifest.json',
  [string]$ContactSheetPath = 'docs\prototypes\screenshots\raby-contact-sheet.png',
  [switch]$SkipVerify
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$distRoot = Resolve-Path (Join-Path $repoRoot 'dist')
$staging = Join-Path $distRoot 'acceptance-bundle-staging'

function Resolve-RepoPath {
  param([Parameter(Mandatory = $true)][string]$Path)
  return Join-Path $repoRoot $Path
}

function Copy-BundleFile {
  param(
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$TargetName
  )

  $source = Resolve-RepoPath $SourcePath
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Bundle source missing: $source"
  }
  $target = Join-Path $staging $TargetName
  $targetDir = Split-Path $target
  if ($targetDir) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
  }
  Copy-Item -LiteralPath $source -Destination $target
}

if (-not ($staging.StartsWith($distRoot.Path, [System.StringComparison]::OrdinalIgnoreCase))) {
  throw "Unsafe staging path: $staging"
}

if (Test-Path -LiteralPath $staging) {
  $resolvedStaging = Resolve-Path $staging
  if (-not ($resolvedStaging.Path.StartsWith($distRoot.Path, [System.StringComparison]::OrdinalIgnoreCase))) {
    throw "Unsafe resolved staging path: $($resolvedStaging.Path)"
  }
  Remove-Item -LiteralPath $resolvedStaging.Path -Recurse -Force
}

New-Item -ItemType Directory -Path $staging | Out-Null

try {
  New-Item -ItemType Directory -Path (Join-Path $staging 'tooling') | Out-Null

  $screenshotPages = @(
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

  Copy-BundleFile -SourcePath 'README.md' -TargetName 'README.md'
  Copy-BundleFile -SourcePath $HandoffPath -TargetName 'raby-v0.1.0-acceptance-handoff.md'
  Copy-BundleFile -SourcePath $RequirementAuditPath -TargetName 'raby-v0.1.0-requirement-audit.md'
  Copy-BundleFile -SourcePath $ManifestPath -TargetName 'raby-v0.1.0-acceptance-manifest.json'
  Copy-BundleFile -SourcePath $ContactSheetPath -TargetName 'raby-contact-sheet.png'
  Copy-BundleFile `
    -SourcePath 'tooling\screenshot_harness\assets\PHOTO_CREDITS.md' `
    -TargetName 'PHOTO_CREDITS.md'
  Copy-BundleFile `
    -SourcePath 'docs\prototypes\screenshots\raby-adb-install-smoke.png' `
    -TargetName 'raby-adb-install-smoke.png'
  foreach ($screenshot in $screenshotPages) {
    Copy-BundleFile `
      -SourcePath (Join-Path 'docs\prototypes\screenshots' $screenshot) `
      -TargetName (Join-Path 'screenshots' $screenshot)
  }
  Copy-BundleFile -SourcePath $ApkPath -TargetName (Split-Path -Leaf $ApkPath)
  Copy-BundleFile -SourcePath $Sha256Path -TargetName (Split-Path -Leaf $Sha256Path)
  Copy-BundleFile `
    -SourcePath 'tooling\create-acceptance-bundle.ps1' `
    -TargetName 'tooling\create-acceptance-bundle.ps1'
  Copy-BundleFile `
    -SourcePath 'tooling\verify-acceptance-artifacts.ps1' `
    -TargetName 'tooling\verify-acceptance-artifacts.ps1'
  Copy-BundleFile `
    -SourcePath 'tooling\publish-public-apk.ps1' `
    -TargetName 'tooling\publish-public-apk.ps1'

  $bundle = Resolve-RepoPath $BundlePath
  if (Test-Path -LiteralPath $bundle) {
    Remove-Item -LiteralPath $bundle -Force
  }
  Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $bundle -CompressionLevel Optimal

  $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $bundle).Hash
  $bundleSha = Resolve-RepoPath $BundleSha256Path
  "$hash  $(Split-Path -Leaf $BundlePath)" | Set-Content -LiteralPath $bundleSha -Encoding ascii

  $bundleFile = Get-Item -LiteralPath $bundle
  Write-Host "Acceptance bundle ready: $($bundleFile.FullName)"
  Write-Host "Bundle size: $($bundleFile.Length) bytes"
  Write-Host "Bundle SHA256: $hash"
} finally {
  if (Test-Path -LiteralPath $staging) {
    for ($attempt = 1; $attempt -le 5; $attempt++) {
      try {
        Remove-Item -LiteralPath $staging -Recurse -Force
        break
      } catch {
        if ($attempt -eq 5) {
          throw
        }
        Start-Sleep -Milliseconds (250 * $attempt)
      }
    }
  }
}

if (-not $SkipVerify) {
  & (Join-Path $PSScriptRoot 'verify-acceptance-artifacts.ps1') `
    -ApkPath $ApkPath `
    -Sha256Path $Sha256Path `
    -BundlePath $BundlePath `
    -BundleSha256Path $BundleSha256Path `
    -HandoffPath $HandoffPath `
    -RequirementAuditPath $RequirementAuditPath `
    -ManifestPath $ManifestPath
  if (-not $?) {
    throw 'Acceptance artifact verification failed.'
  }
}

