@echo off
chcp 65001 >nul 2>&1
title TeleHub with Tuna Tunnel

echo ==========================================
echo      TeleHub WebApp - Tuna Tunnel
echo ==========================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found! Please install Python 3.10+
    pause
    exit /b 1
)

REM Check tuna.exe
if not exist "tuna.exe" (
    echo [ERROR] tuna.exe not found!
    echo [INFO] Please ensure tuna.exe is in the project folder
    echo [INFO] If you don't have it, try run_with_ngrok_fixed.bat instead
    pause
    exit /b 1
)

echo [OK] tuna.exe found
echo.

REM Set tunnel URL
set TUNNEL_URL=https://mybotadmin.ru.tuna.am

REM Update URL in code
echo [INFO] Updating WebApp URL to: %TUNNEL_URL%
python update_webapp_url_windows.py %TUNNEL_URL%
if errorlevel 1 (
    echo [WARNING] Failed to update URL automatically
)
echo.

echo [INFO] WebApp Configuration:
echo   URL: %TUNNEL_URL%
echo   Access: Public (via tuna tunnel)
echo   Port: 8080 (local)
echo.

echo [INFO] Starting services in sequence...
echo.

REM Start WebApp server first
echo [1/4] Starting WebApp Server...
start "TeleHub WebApp Server" cmd /k "title WebApp Server && echo [WebApp] Starting on port 8080... && python scr/app/app.py"
timeout /t 5 /nobreak >nul

REM Start tuna tunnel
echo [2/4] Starting Tuna Tunnel...
start "TeleHub Tuna Tunnel" cmd /k "title Tuna Tunnel && echo [Tuna] Creating tunnel to localhost:8080... && tuna http 8080 --subdomain=mybotadmin"
timeout /t 10 /nobreak >nul

REM Start Telegram bot
echo [3/4] Starting Telegram Bot...
start "TeleHub Telegram Bot" cmd /k "title Telegram Bot && echo [Bot] Starting Telegram bot... && python scr/bot/bot.py"
timeout /t 3 /nobreak >nul

REM Start parser
echo [4/4] Starting Parser...
start "TeleHub Parser" cmd /k "title Parser && echo [Parser] Starting parser service... && python scr/parser/parser.py"
timeout /t 2 /nobreak >nul

echo ==========================================
echo           All Services Started!
echo ==========================================
echo.
echo WebApp URL: %TUNNEL_URL%
echo Local URL:  http://localhost:8080
echo.
echo Service Windows:
echo - WebApp Server (check for errors)
echo - Tuna Tunnel (should show tunnel URL)
echo - Telegram Bot (should show "Bot started")
echo - Parser (parsing service)
echo.
echo Testing instructions:
echo 1. Wait 1-2 minutes for tunnel initialization
echo 2. Test local: http://localhost:8080
echo 3. Test public: %TUNNEL_URL%
echo 4. Send /start to your bot in Telegram
echo 5. Click "Admin Panel" button
echo.
echo Troubleshooting:
echo - If tunnel fails: Check Tuna Tunnel window for errors
echo - If bot fails: Check config.ini settings
echo - If WebApp fails: Check port 8080 availability
echo.
echo [INFO] Monitoring services... Close this window to stop everything
echo.

:monitor_loop
timeout /t 60 /nobreak >nul
echo [%date% %time%] Services running... Tunnel: %TUNNEL_URL%
goto monitor_loop