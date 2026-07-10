param(
  [string]$RepoRoot,
  [switch]$RequireTracked,
  [string]$RemoteRef
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  $RepoRoot = Join-Path $PSScriptRoot '..\..\..\..'
}

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
$pubspec = Join-Path $RepoRoot 'pubspec.yaml'
if (-not (Test-Path -LiteralPath $pubspec)) {
  throw "pubspec.yaml not found under $RepoRoot"
}

$assetPaths = foreach ($line in Get-Content -LiteralPath $pubspec) {
  if ($line -match '^\s*-\s+asset:\s*(assets/.+?)\s*$') {
    $Matches[1].Trim()
  } elseif ($line -match '^\s*-\s+(assets/.+?)\s*$') {
    $Matches[1].Trim()
  }
}
$assetPaths = @($assetPaths | Sort-Object -Unique)

if ($assetPaths.Count -eq 0) {
  throw 'No assets were found in pubspec.yaml.'
}

$missing = [System.Collections.Generic.List[string]]::new()
$untracked = [System.Collections.Generic.List[string]]::new()
$missingRemote = [System.Collections.Generic.List[string]]::new()

Push-Location $RepoRoot
try {
  foreach ($assetPath in $assetPaths) {
    $localPath = Join-Path $RepoRoot ($assetPath -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $localPath)) {
      $missing.Add($assetPath)
      continue
    }

    if ($RequireTracked) {
      & git ls-files --error-unmatch -- $assetPath 2>$null | Out-Null
      if ($LASTEXITCODE -ne 0) {
        $untracked.Add($assetPath)
      }
    }

    if (-not [string]::IsNullOrWhiteSpace($RemoteRef)) {
      $objectSpec = "${RemoteRef}:$assetPath"
      & git cat-file -e $objectSpec 2>$null
      if ($LASTEXITCODE -ne 0) {
        $missingRemote.Add($assetPath)
      }
    }
  }
} finally {
  Pop-Location
}

Write-Host "Declared assets: $($assetPaths.Count)"
Write-Host "Missing locally: $($missing.Count)"
if ($RequireTracked) {
  Write-Host "Not tracked by Git: $($untracked.Count)"
}
if (-not [string]::IsNullOrWhiteSpace($RemoteRef)) {
  Write-Host "Missing from ${RemoteRef}: $($missingRemote.Count)"
}

$problems = @(
  $missing | ForEach-Object { "missing local: $_" }
  $untracked | ForEach-Object { "not tracked: $_" }
  $missingRemote | ForEach-Object { "missing remote: $_" }
)

if ($problems.Count -gt 0) {
  $problems | ForEach-Object { Write-Error $_ }
  throw "Asset verification failed with $($problems.Count) problem(s)."
}

Write-Host 'Asset verification passed.'
