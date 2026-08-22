@echo off
setlocal
cd /d "%~dp0"

where pwsh.exe >nul 2>nul
if not errorlevel 1 (
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-codex-sayram.ps1" %*
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-codex-sayram.ps1" %*
)

set "exitCode=%errorlevel%"
if not "%exitCode%"=="0" (
    echo.
    echo The Codex theme launcher failed with exit code %exitCode%.
    echo If Codex was already opened normally, close it and run this file again.
    pause
)
exit /b %exitCode%
