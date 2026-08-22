[CmdletBinding()]
param(
    [int]$Port = 9335
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$applyScript = Join-Path $scriptDir "apply-codex-sayram.ps1"
$userHome = [Environment]::GetFolderPath("UserProfile")
$codexConfigPath = Join-Path $userHome ".codex\config.toml"

$npxCommand = (Get-Command npx.cmd -ErrorAction SilentlyContinue).Source
if ([string]::IsNullOrWhiteSpace($npxCommand)) {
    $npxCommand = (Get-Command npx.exe -ErrorAction SilentlyContinue).Source
}
if ([string]::IsNullOrWhiteSpace($npxCommand)) {
    throw "Node.js 22.4+ is required. Install Node.js, then run this script again."
}
if (-not (Test-Path -LiteralPath $applyScript)) { throw "Missing apply script: $applyScript" }

$beforeHash = $null
if (Test-Path -LiteralPath $codexConfigPath) {
    $beforeHash = (Get-FileHash -LiteralPath $codexConfigPath -Algorithm SHA256).Hash
}

$env:NO_UPDATE_NOTIFIER = "1"
Write-Host "Starting Codex with the Sayram Lake · Tianshan Morning theme..."
Write-Host "The launcher uses loopback CDP on 127.0.0.1:$Port and never passes --restart-existing."

& $npxCommand --yes "--package=@codedrobe/core@0.6.0" codedrobe launch `
    --app codex `
    --port $Port `
    --json
$launchExitCode = $LASTEXITCODE
if ($launchExitCode -ne 0) {
    throw "Codex was not launched with the theme endpoint. Close the normally opened Codex window, then run this script again. Exit code: $launchExitCode"
}

& $applyScript -Port $Port
if ($LASTEXITCODE -ne 0) {
    throw "The theme could not be applied."
}

$afterHash = $null
if (Test-Path -LiteralPath $codexConfigPath) {
    $afterHash = (Get-FileHash -LiteralPath $codexConfigPath -Algorithm SHA256).Hash
}
if ($beforeHash -ne $afterHash) {
    throw "Safety stop: .codex/config.toml changed unexpectedly."
}

Write-Host "Sayram Lake · Tianshan Morning is active."
