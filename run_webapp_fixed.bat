@echo off
chcp 65001 >nul 2>&1
title TeleHub WebApp

echo ==========================================
echo          TeleHub WebApp Launcher
echo ==========================================
echo.

REM Set PYTHONPATH to include project root
set PYTHONPATH=%CD%;%PYTHONPATH%
echo [INFO] Python path set to: %CD%

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

REM Check if port 8080 is available
netstat -an | findstr ":8080" >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Port 8080 is in use
    echo [INFO] Trying to free the port...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080"') do (
        if not "%%a"=="0" (
            taskkill /f /pid %%a >nul 2>&1
        )
    )
    timeout /t 2 /nobreak >nul
)

echo [INFO] Starting WebApp server...
echo [INFO] WebApp will be available at: http://localhost:8080
echo [INFO] Press Ctrl+C to stop
echo.

REM Change to project root and run webapp
cd /d "%~dp0"
python -m scr.app.app

if errorlevel 1 (
    echo.
    echo [ERROR] WebApp failed to start!
    echo [INFO] Common issues:
    echo   - Port 8080 might be in use
    echo   - Check if all dependencies are installed
    echo   - Try: pip install -r requirements.txt
    echo.
    pause
)