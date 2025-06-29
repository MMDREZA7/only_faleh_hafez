flutter build apk

$pubspec = Get-Content ./pubspec.yaml
$versionLine = $pubspec | Where-Object { $_ -match '^version:' }
$version = ($versionLine -split ' ')[1] -split '\+' | Select-Object -First 1

if (!(Test-Path -Path "appVersions")) {
    New-Item -ItemType Directory -Path "appVersions"
}

$apkSource = "build\app\outputs\flutter-apk\app-release.apk"
$apkDest = "appVersions\app_v$version.apk"

Copy-Item -Path $apkSource -Destination $apkDest -Force

Remove-Item -Path $apkSource

$version | Out-File -Encoding ASCII -FilePath "lib\app_version.txt"

Write-Host "✅ Done: APK saved to $apkDest and original deleted."
