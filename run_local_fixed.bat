@echo off
chcp 65001 >nul 2>&1
title TeleHub Local WebApp

echo ==========================================
echo       TeleHub WebApp - Local Testing
echo ==========================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found! Please install Python 3.10+
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
    echo [WARNING] Could not detect local IP, using localhost
) else (
    echo [INFO] Local IP detected: %LOCAL_IP%
)

set WEBAPP_URL=http://%LOCAL_IP%:8080

REM Update URL in code
echo [INFO] Updating WebApp URL to: %WEBAPP_URL%
python update_webapp_url_windows.py %WEBAPP_URL%
if errorlevel 1 (
    echo [WARNING] Failed to update URL automatically
    echo [INFO] You may need to update it manually
)
echo.

echo [INFO] WebApp Configuration:
echo   URL: %WEBAPP_URL%
echo   Access: Local network only
echo   Port: 8080
echo.

REM Check if port 8080 is available
netstat -an | findstr ":8080" >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Port 8080 appears to be in use
    echo [INFO] If you get errors, kill existing processes:
    echo   netstat -ano ^| findstr :8080
    echo   taskkill /f /pid PID_NUMBER
    echo.
)

echo [INFO] Starting services...
echo.

REM Start WebApp server
echo [STARTING] WebApp Server...
start "TeleHub WebApp Server" cmd /k "title WebApp Server && echo WebApp Server starting... && python scr/app/app.py"
timeout /t 3 /nobreak >nul

REM Start Telegram bot
echo [STARTING] Telegram Bot...
start "TeleHub Telegram Bot" cmd /k "title Telegram Bot && echo Telegram Bot starting... && python scr/bot/bot.py"
timeout /t 2 /nobreak >nul

echo ==========================================
echo             Services Started!
echo ==========================================
echo.
echo WebApp URL: %WEBAPP_URL%
echo Bot status: Check "Telegram Bot" window
echo Web status: Check "WebApp Server" window
echo.
echo Testing instructions:
echo 1. Open %WEBAPP_URL% in browser to test web interface
echo 2. Send /start to your bot in Telegram
echo 3. Click "Admin Panel" button if it appears
echo.
echo [INFO] Close this window or press Ctrl+C to stop all services
echo.

:wait_loop
timeout /t 30 /nobreak >nul
echo [%date% %time%] Services running... (Close this window to stop)
goto wait_loop