param(
  [switch]$Bundle = $false,
  [switch]$PerAbi = $false,
  [string]$SymbolsRoot = "symbols",
  [string]$OutRoot = "appVersions"
)

# --- Extract version from pubspec.yaml ---
$pubspec = Get-Content ./pubspec.yaml
$versionLine = $pubspec | Where-Object { $_ -match '^version:' }
if (-not $versionLine) { throw "Version not found in pubspec.yaml" }
$version = ($versionLine -split ' ')[1] -split '\+' | Select-Object -First 1

# --- Prepare directories ---
$symbolsDir = Join-Path $SymbolsRoot $version
$outDir = Join-Path $OutRoot $version
New-Item -ItemType Directory -Path $symbolsDir,$outDir -Force | Out-Null

# --- Build command ---
if ($Bundle) {
  flutter build appbundle --release --obfuscate --split-debug-info="$symbolsDir"
} else {
  $splitAbiFlag = ""
  if ($PerAbi) { $splitAbiFlag = "--split-per-abi" }
  flutter build apk --release --obfuscate --split-debug-info="$symbolsDir" $splitAbiFlag
}

# --- Copy outputs ---
if ($Bundle) {
  $aab = "build\app\outputs\bundle\release\app-release.aab"
  if (!(Test-Path $aab)) { throw "AAB not found: $aab" }
  $dest = Join-Path $outDir ("app-release_v{0}.aab" -f $version)
  Copy-Item $aab $dest -Force
} else {
  $apkDir = "build\app\outputs\flutter-apk"
  $apks = Get-ChildItem -Path $apkDir -Filter "*.apk" -ErrorAction SilentlyContinue
  if ($apks.Count -eq 0) { throw "No APKs found in $apkDir" }
  foreach ($apk in $apks) {
    $name = [IO.Path]::GetFileNameWithoutExtension($apk.FullName)
    $dest = Join-Path $outDir ("{0}_v{1}.apk" -f $name, $version)
    Copy-Item -Path $apk.FullName -Destination $dest -Force
  }
}

# --- Write version file ---
$versionFilePath = "lib/version.dart"
if (!(Test-Path $versionFilePath)) { New-Item -ItemType File -Path $versionFilePath | Out-Null }
"final appVersion = '$version';" | Set-Content $versionFilePath -Encoding UTF8

Write-Host "✅ Done."
Write-Host "   Out: $outDir"
Write-Host "   Symbols: $symbolsDir"
Write-Host "   Version: $version"
