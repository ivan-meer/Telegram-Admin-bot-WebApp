@echo off
chcp 65001 >nul 2>&1
title Quick WebApp Test

echo ==========================================
echo         Quick WebApp Test
echo ==========================================
echo.

REM Check current config
echo [INFO] Current configuration:
python update_webapp_config.py --show

echo.
echo [INFO] Testing WebApp server startup...

REM Kill any existing python processes on port 8080
echo [INFO] Cleaning up any existing processes...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080"') do (
    if not "%%a"=="0" (
        taskkill /f /pid %%a >nul 2>&1
    )
)

REM Start server in background
echo [INFO] Starting WebApp server...
start /min "Test WebApp" cmd /c "python scr/app/app.py"

REM Wait a bit
timeout /t 5 /nobreak >nul

REM Test server response
echo [INFO] Testing server response...
curl -s http://localhost:8080 >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Server not responding
    echo [INFO] Check if there are any Python errors
) else (
    echo [SUCCESS] Server is responding!
    echo [INFO] WebApp is working on http://localhost:8080
)

echo.
echo [INFO] Now test the bot:
echo 1. Run: python scr/bot/bot.py
echo 2. Send /start to your bot in Telegram  
echo 3. Look for "Admin Panel" button
echo.

REM Cleanup
echo [INFO] Stopping test server...
taskkill /f /im python.exe >nul 2>&1

pause