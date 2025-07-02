@echo off
chcp 65001 >nul 2>&1
title TeleHub Complete System

echo ==========================================
echo       TeleHub Complete System Launcher
echo ==========================================
echo.

REM Set PYTHONPATH
set PYTHONPATH=%CD%;%PYTHONPATH%

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

REM Get local IP
set LOCAL_IP=
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4" ^| findstr "192.168"') do (
    for /f "tokens=1" %%j in ("%%i") do set LOCAL_IP=%%j
)

if "%LOCAL_IP%"=="" (
    set LOCAL_IP=localhost
)

set WEBAPP_URL=http://%LOCAL_IP%:8080

REM Update config with current URL
echo [INFO] Updating WebApp URL to: %WEBAPP_URL%
python update_webapp_config.py %WEBAPP_URL%

echo [INFO] Starting system components...
echo.

REM Clean up any existing processes
echo [CLEANUP] Stopping any existing processes...
taskkill /f /im python.exe >nul 2>&1
timeout /t 2 /nobreak >nul

REM Start WebApp server
echo [1/2] Starting WebApp Server...
start "TeleHub WebApp" cmd /k "title WebApp Server && echo WebApp starting... && set PYTHONPATH=%CD% && python -m scr.app.app"
timeout /t 5 /nobreak >nul

REM Test WebApp
echo [INFO] Testing WebApp server...
curl -s http://localhost:8080 >nul 2>&1
if errorlevel 1 (
    echo [WARNING] WebApp may not be ready yet
) else (
    echo [SUCCESS] WebApp is responding
)

REM Start Bot
echo [2/2] Starting Telegram Bot...
start "TeleHub Bot" cmd /k "title Telegram Bot && echo Bot starting... && set PYTHONPATH=%CD% && python -m scr.bot.bot"

echo.
echo ==========================================
echo            System Started!
echo ==========================================
echo.
echo WebApp URL: %WEBAPP_URL%
echo Local test: http://localhost:8080
echo.
echo Two windows should have opened:
echo - WebApp Server (check for errors)
echo - Telegram Bot (should show "Bot started")
echo.
echo Testing steps:
echo 1. Open %WEBAPP_URL% in browser
echo 2. Send /start to your bot in Telegram
echo 3. Look for "Admin Panel" button
echo 4. Click the button to open WebApp
echo.
echo [INFO] Close this window or press any key to monitor...
pause