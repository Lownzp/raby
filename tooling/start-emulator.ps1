param(
    [string]$AvdName = 'Medium_Phone_API_36.1'
)

. "$PSScriptRoot\env.ps1"

$running = adb devices | Select-String -Pattern 'emulator-\d+\s+device'
if ($running) {
    Write-Output 'Android emulator is already running.'
    flutter devices
    exit 0
}

Start-Process -FilePath (Join-Path $env:ANDROID_SDK_ROOT 'emulator\emulator.exe') `
    -ArgumentList @('-avd', $AvdName, '-no-audio', '-gpu', 'swiftshader_indirect') `
    -WindowStyle Hidden

Write-Output "Started Android emulator: $AvdName"
