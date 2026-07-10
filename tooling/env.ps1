$FlutterRoot = 'D:\work\toolchains\flutter'
$AndroidSdkRoot = Join-Path $env:LOCALAPPDATA 'Android\Sdk'
$JdkRoot = 'C:\Program Files\Java\jdk-17'

$env:FLUTTER_ROOT = $FlutterRoot
$env:ANDROID_HOME = $AndroidSdkRoot
$env:ANDROID_SDK_ROOT = $AndroidSdkRoot
$env:JAVA_HOME = $JdkRoot

$paths = @(
    (Join-Path $FlutterRoot 'bin'),
    (Join-Path $JdkRoot 'bin'),
    (Join-Path $AndroidSdkRoot 'cmdline-tools\latest\bin'),
    (Join-Path $AndroidSdkRoot 'platform-tools'),
    (Join-Path $AndroidSdkRoot 'emulator')
)

$existing = $env:Path -split ';'
$env:Path = (($paths + $existing) | Where-Object { $_ -and ($_ -notin @('', $null)) } | Select-Object -Unique) -join ';'

Write-Output "Raby dev environment loaded."
Write-Output "Flutter: $FlutterRoot"
Write-Output "Android SDK: $AndroidSdkRoot"
Write-Output "JDK: $JdkRoot"
