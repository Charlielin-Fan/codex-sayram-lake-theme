@echo off
setlocal
cd /d "%~dp0"

where pwsh.exe >nul 2>nul
if not errorlevel 1 (
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\restore-codex-sayram.ps1" %*
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\restore-codex-sayram.ps1" %*
)

set "exitCode=%errorlevel%"
if not "%exitCode%"=="0" pause
exit /b %exitCode%
