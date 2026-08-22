[CmdletBinding()]
param(
    [int]$Port = 9335
)

$ErrorActionPreference = "Stop"
$userHome = [Environment]::GetFolderPath("UserProfile")
$codexConfigPath = Join-Path $userHome ".codex\config.toml"
$npxCommand = (Get-Command npx.cmd -ErrorAction SilentlyContinue).Source
if ([string]::IsNullOrWhiteSpace($npxCommand)) {
    $npxCommand = (Get-Command npx.exe -ErrorAction SilentlyContinue).Source
}
if ([string]::IsNullOrWhiteSpace($npxCommand)) {
    throw "Node.js 22.4+ is required. Install Node.js, then run this script again."
}

$beforeHash = $null
if (Test-Path -LiteralPath $codexConfigPath) {
    $beforeHash = (Get-FileHash -LiteralPath $codexConfigPath -Algorithm SHA256).Hash
}

$env:NO_UPDATE_NOTIFIER = "1"
Write-Host "Removing the renderer-only Sayram Lake theme..."
& $npxCommand --yes "--package=@codedrobe/core@0.6.0" codedrobe restore `
    --app codex `
    --port $Port `
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
    throw "Theme cleanup did not complete. Codex configuration was unchanged. Exit code: $exitCode"
}

Write-Host "Renderer-only theme cleanup completed."
