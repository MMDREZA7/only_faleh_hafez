flutter build apk

$pubspec = Get-Content ./pubspec.yaml
$versionLine = $pubspec | Where-Object { $_ -match '^version:' }
$version = ($versionLine -split ' ')[1] -split '\+' | Select-Object -First 1
$buildNumber = ($versionLine -split ' ')[1] -split '\+' | Select-Object -Last 1

if (!(Test-Path -Path "appVersions")) {
    New-Item -ItemType Directory -Path "appVersions"
}

$apkSource = "build\app\outputs\flutter-apk\app-release.apk"
$apkDest = "appVersions\app_v$version+$buildNumber.apk"

Copy-Item -Path $apkSource -Destination $apkDest -Force
Remove-Item -Path $apkSource

$versionFilePath = "lib/version.dart"

if (!(Test-Path -Path $versionFilePath)) {
    New-Item -ItemType File -Path $versionFilePath
}

$dartFileContent = @"
/// GENERATED FILE - DO NOT EDIT
/// This file is automatically updated after flutter build.

final appVersion = '$version+$buildNumber';
"@

Set-Content -Path $versionFilePath -Value $dartFileContent -Encoding UTF8

Write-Host "✅ Done: APK saved to $apkDest, version.dart updated with appVersion = $version+$buildNumber"
