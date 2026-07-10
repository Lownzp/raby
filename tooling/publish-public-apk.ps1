param(
  [string]$ReleaseName = 'raby-v0.1.0',
  [string]$OutputDir = 'dist\apk',
  [switch]$SkipBuild,
  [switch]$NoUpload,
  [string]$FlutterSdk = '',
  [string]$BashPath = 'D:\devTools\Git\bin\bash.exe',
  [string]$EnvFile = 'D:\work\proj\zhxj\znxj-cloud\dev\frontend\znxj-frontend-prod-0.52\scripts\local.env',
  [string]$PublicUrlPrefix = 'http://103.8.33.7:8800/files/znxj',
  [int]$UploadTimeoutSec = 300
)

$ErrorActionPreference = 'Stop'

function ConvertTo-BashPath {
  param([Parameter(Mandatory = $true)][string]$Path)

  $resolved = Resolve-Path -LiteralPath $Path
  $normalized = $resolved.ProviderPath -replace '\\', '/'
  if ($normalized -match '^([A-Za-z]):/(.*)$') {
    return "/$($matches[1].ToLower())/$($matches[2])"
  }
  return $normalized
}

function Get-FlutterBatPath {
  param([string]$RequestedSdk)

  if ($RequestedSdk) {
    $flutter = Join-Path $RequestedSdk 'bin\flutter.bat'
    if (Test-Path -LiteralPath $flutter) {
      return $flutter
    }
    throw "Flutter SDK not found: $RequestedSdk"
  }

  $localProperties = Join-Path $repoRoot 'android\local.properties'
  if (Test-Path -LiteralPath $localProperties) {
    $sdkLine = Get-Content -LiteralPath $localProperties |
      Where-Object { $_ -like 'flutter.sdk=*' } |
      Select-Object -First 1
    if ($sdkLine) {
      $sdk = ($sdkLine -replace '^flutter\.sdk=', '') -replace '\\\\', '\'
      $flutter = Join-Path $sdk 'bin\flutter.bat'
      if (Test-Path -LiteralPath $flutter) {
        return $flutter
      }
    }
  }

  $defaultFlutter = 'D:\work\toolchains\flutter\bin\flutter.bat'
  if (Test-Path -LiteralPath $defaultFlutter) {
    return $defaultFlutter
  }

  $fromPath = Get-Command flutter -ErrorAction SilentlyContinue
  if ($fromPath) {
    return $fromPath.Source
  }

  throw 'Flutter executable not found. Pass -FlutterSdk or load tooling\env.ps1 first.'
}

function Format-SizeMb {
  param([long]$Bytes)
  return ('{0:N1}MB' -f ($Bytes / 1MB))
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$flutter = Get-FlutterBatPath -RequestedSdk $FlutterSdk

if (-not $NoUpload -and -not (Test-Path -LiteralPath $BashPath)) {
  throw "Git Bash not found: $BashPath"
}

if (-not $NoUpload -and -not (Test-Path -LiteralPath $EnvFile)) {
  throw "Upload env file not found: $EnvFile"
}

if (-not $SkipBuild) {
  Write-Host 'Building Android arm64 release APK...'
  & $flutter build apk --release --target-platform android-arm64 --split-per-abi
  if ($LASTEXITCODE -ne 0) {
    throw "Flutter build failed with exit code $LASTEXITCODE"
  }
} else {
  Write-Host 'SkipBuild enabled; using existing release APK.'
}

$sourceApk = Join-Path $repoRoot 'build\app\outputs\flutter-apk\app-arm64-v8a-release.apk'
if (-not (Test-Path -LiteralPath $sourceApk)) {
  throw "Release APK not found: $sourceApk"
}

$safeReleaseName = ($ReleaseName -replace '[^A-Za-z0-9_.-]+', '-').Trim('-')
if (-not $safeReleaseName) {
  throw 'ReleaseName becomes empty after sanitizing.'
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$outputRoot = Join-Path $repoRoot $OutputDir
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null

$apkName = "$safeReleaseName-arm64-release-$timestamp.apk"
$outputApk = Join-Path $outputRoot $apkName
Copy-Item -LiteralPath $sourceApk -Destination $outputApk -Force

$apk = Get-Item -LiteralPath $outputApk
Write-Host "APK ready: $($apk.FullName)"
Write-Host "APK size: $($apk.Length) bytes ($(Format-SizeMb $apk.Length))"

if ($NoUpload) {
  Write-Host 'NoUpload enabled; skip public upload.'
  return
}

$bashEnvFile = ConvertTo-BashPath -Path $EnvFile
$bashApk = ConvertTo-BashPath -Path $outputApk

$uploadScript = @'
set -euo pipefail

ENV_FILE="$1"
FILE="$2"
PUBLIC_URL_PREFIX="$3"
UPLOAD_TIMEOUT="$4"

# shellcheck source=/dev/null
. "$ENV_FILE"

if [[ -z "${ZNXJ_UPLOAD_PASS:-}" ]]; then
  echo "ZNXJ_UPLOAD_PASS is missing in $ENV_FILE" >&2
  exit 2
fi

if [[ ! -f "$FILE" ]]; then
  echo "APK not found: $FILE" >&2
  exit 2
fi

NAME="$(basename "$FILE")"
DIR="$(dirname "$FILE")"
UPLOAD_SERVER="${ZNXJ_UPLOAD_SERVER:-10.103.142.13}"
UPLOAD_USER="${ZNXJ_UPLOAD_USER:-root}"
UPLOAD_DIR="${ZNXJ_UPLOAD_DIR:-/iflytek/zbg/lygq_upload/znxj}"
LOCAL_SIZE="$(stat -c %s "$FILE")"

export SSHPASS="$ZNXJ_UPLOAD_PASS"
trap 'unset SSHPASS' EXIT

echo "Uploading to $UPLOAD_SERVER:$UPLOAD_DIR/$NAME ..."
(
  cd "$DIR"
  timeout "$UPLOAD_TIMEOUT" sshpass -e /c/Windows/System32/OpenSSH/scp.exe \
    -o StrictHostKeyChecking=no \
    -o LogLevel=ERROR \
    "$NAME" "$UPLOAD_USER@$UPLOAD_SERVER:$UPLOAD_DIR/" 2>/dev/null
)

REMOTE_SIZE="$(
  timeout 30 sshpass -e /c/Windows/System32/OpenSSH/ssh.exe \
    -o StrictHostKeyChecking=no \
    -o LogLevel=ERROR \
    "$UPLOAD_USER@$UPLOAD_SERVER" \
    "stat -c %s '$UPLOAD_DIR/$NAME' 2>/dev/null" 2>/dev/null |
    grep -oE '[0-9]+' |
    head -1
)"

if [[ "$REMOTE_SIZE" != "$LOCAL_SIZE" ]]; then
  echo "Upload verification failed: local=$LOCAL_SIZE remote=${REMOTE_SIZE:-empty}" >&2
  exit 1
fi

echo "Upload verified: $REMOTE_SIZE bytes"
echo "Public URL: $PUBLIC_URL_PREFIX/$NAME"
'@

$tempUploadScript = Join-Path ([System.IO.Path]::GetTempPath()) "raby-upload-$timestamp-$PID.sh"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($tempUploadScript, $uploadScript, $utf8NoBom)

try {
  $bashUploadScript = ConvertTo-BashPath -Path $tempUploadScript
  & $BashPath $bashUploadScript $bashEnvFile $bashApk $PublicUrlPrefix "$UploadTimeoutSec"
  if ($LASTEXITCODE -ne 0) {
    throw "Upload failed with exit code $LASTEXITCODE"
  }
} finally {
  Remove-Item -LiteralPath $tempUploadScript -Force -ErrorAction SilentlyContinue
}
