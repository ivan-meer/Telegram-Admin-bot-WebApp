@echo off
chcp 65001 >nul 2>&1
title TeleHub Local WebApp (Alternative Port)

echo ==========================================
echo    TeleHub WebApp - Local (Alt Port)
echo ==========================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found! Please install Python 3.10+
    pause
    exit /b 1
)

REM Find available port
set PORT=8080
netstat -an | findstr ":8080" >nul 2>&1
if not errorlevel 1 (
    echo [WARNING] Port 8080 is busy, trying 8081...
    set PORT=8081
    netstat -an | findstr ":8081" >nul 2>&1
    if not errorlevel 1 (
        echo [WARNING] Port 8081 is busy, trying 8082...
        set PORT=8082
    )
)

echo [INFO] Using port: %PORT%

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

set WEBAPP_URL=http://%LOCAL_IP%:%PORT%

REM Update port in app.py if needed
if not "%PORT%"=="8080" (
    echo [INFO] Updating app.py to use port %PORT%...
    python -c "
import re
try:
    with open('scr/app/app.py', 'r', encoding='utf-8') as f:
        content = f.read()
    content = re.sub(r'port=\d+', 'port=%PORT%', content)
    with open('scr/app/app.py', 'w', encoding='utf-8') as f:
        f.write(content)
    print('[OK] Updated app.py port')
except Exception as e:
    print(f'[WARNING] Could not update port: {e}')
    "
)

REM Update URL in code
echo [INFO] Updating WebApp URL to: %WEBAPP_URL%
python update_webapp_url_windows.py %WEBAPP_URL%
if errorlevel 1 (
    echo [WARNING] Failed to update URL automatically
)
echo.

echo [INFO] WebApp Configuration:
echo   URL: %WEBAPP_URL%
echo   Port: %PORT%
echo   Access: Local network only
echo.

echo [INFO] Starting services...
echo.

REM Start WebApp server with custom port
echo [STARTING] WebApp Server on port %PORT%...
start "TeleHub WebApp Server" cmd /k "title WebApp Server (Port %PORT%) && echo WebApp Server starting on port %PORT%... && python scr/app/app.py"
timeout /t 5 /nobreak >nul

REM Test if server started
echo [INFO] Testing server startup...
timeout /t 3 /nobreak >nul
curl -s http://localhost:%PORT% >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Server may not have started properly
    echo [INFO] Check the WebApp Server window for errors
) else (
    echo [SUCCESS] Server is responding on port %PORT%
)

REM Start Telegram bot
echo [STARTING] Telegram Bot...
start "TeleHub Telegram Bot" cmd /k "title Telegram Bot && echo Telegram Bot starting... && python scr/bot/bot.py"
timeout /t 2 /nobreak >nul

echo ==========================================
echo             Services Started!
echo ==========================================
echo.
echo WebApp URL: %WEBAPP_URL%
echo Local Test: http://localhost:%PORT%
echo Bot status: Check "Telegram Bot" window
echo Web status: Check "WebApp Server" window
echo.
echo Testing instructions:
echo 1. Open http://localhost:%PORT% in browser
echo 2. Send /start to your bot in Telegram
echo 3. Click "Admin Panel" button if it appears
echo.
echo [INFO] Press Ctrl+C in any window to stop services
echo [INFO] Or close this window to continue monitoring
echo.

:wait_loop
timeout /t 30 /nobreak >nul
echo [%date% %time%] Services running on port %PORT%...
goto wait_loop