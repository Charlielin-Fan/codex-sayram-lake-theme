[CmdletBinding()]
param(
    [int]$Port = 9335
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$manifestPath = Join-Path $projectRoot "theme.json"
$packagePath = Join-Path $projectRoot "dist\codex-sayram-lake-theme.codedrobe-theme"
$userHome = [Environment]::GetFolderPath("UserProfile")
$codexConfigPath = Join-Path $userHome ".codex\config.toml"

$npxCommand = (Get-Command npx.cmd -ErrorAction SilentlyContinue).Source
if ([string]::IsNullOrWhiteSpace($npxCommand)) {
    $npxCommand = (Get-Command npx.exe -ErrorAction SilentlyContinue).Source
}

if (-not (Test-Path -LiteralPath $manifestPath)) { throw "Missing theme manifest: $manifestPath" }
if (-not (Test-Path -LiteralPath $packagePath)) { throw "Missing theme package: $packagePath" }
if ([string]::IsNullOrWhiteSpace($npxCommand)) {
    throw "Node.js 22.4+ is required. Install Node.js, then run this script again."
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$codexOptions = $manifest.targets.codex.options
if ($null -ne $codexOptions -and $null -ne $codexOptions.baseTheme) {
    throw "Safety stop: this theme must not request a native Codex base theme."
}

$beforeHash = $null
if (Test-Path -LiteralPath $codexConfigPath) {
    $beforeHash = (Get-FileHash -LiteralPath $codexConfigPath -Algorithm SHA256).Hash
}

$env:NO_UPDATE_NOTIFIER = "1"
Write-Host "Applying Sayram Lake · Tianshan Morning to the existing Codex renderer..."
Write-Host "Safety mode: loopback CDP only; no restart and no native Codex settings."

& $npxCommand --yes "--package=@codedrobe/core@0.6.0" codedrobe apply `
    --app codex `
    --theme $packagePath `
    --port $Port `
    --no-launch `
    --json
$exitCode = $LASTEXITCODE

$afterHash = $null
if (Test-Path -LiteralPath $codexConfigPath) {
    $afterHash = (Get-FileHash -LiteralPath $codexConfigPath -Algorithm SHA256).Hash
}
if ($beforeHash -ne $afterHash) {
    throw "Safety stop: .codex/config.toml changed unexpectedly."
}
if ($exitCode -ne 0) {
    throw "Theme was not applied. Close Codex and use Start-Codex-Sayram.cmd if it was opened normally. Exit code: $exitCode"
}

Write-Host "Theme applied. Codex configuration was unchanged."
