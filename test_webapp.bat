@echo off
chcp 65001 >nul 2>&1
title TeleHub WebApp Test

echo ==========================================
echo         TeleHub WebApp Quick Test
echo ==========================================
echo.

echo [INFO] This script will help diagnose WebApp issues
echo.

REM Test 1: Python
echo [TEST 1] Checking Python...
python --version
if errorlevel 1 (
    echo [FAIL] Python not found
    echo [INFO] Install Python from python.org
    goto end
) else (
    echo [PASS] Python OK
)
echo.

REM Test 2: Required files
echo [TEST 2] Checking required files...
if exist "scr\bot\bot.py" (
    echo [PASS] bot.py found
) else (
    echo [FAIL] bot.py not found
)

if exist "scr\app\app.py" (
    echo [PASS] app.py found
) else (
    echo [FAIL] app.py not found
)

if exist "config.ini" (
    echo [PASS] config.ini found
) else (
    echo [FAIL] config.ini not found
    echo [INFO] Create config.ini with your bot settings
)

if exist "requirements.txt" (
    echo [PASS] requirements.txt found
) else (
    echo [FAIL] requirements.txt not found
)
echo.

REM Test 3: Dependencies
echo [TEST 3] Checking key dependencies...
python -c "import aiogram; print('[PASS] aiogram imported')" 2>nul || echo [FAIL] aiogram not installed
python -c "import fastapi; print('[PASS] fastapi imported')" 2>nul || echo [FAIL] fastapi not installed
python -c "import uvicorn; print('[PASS] uvicorn imported')" 2>nul || echo [FAIL] uvicorn not installed
echo.

REM Test 4: Port availability
echo [TEST 4] Checking port 8080...
netstat -an | findstr ":8080" >nul 2>&1
if errorlevel 1 (
    echo [PASS] Port 8080 is available
) else (
    echo [WARNING] Port 8080 is in use
    echo [INFO] You may need to kill existing processes
)
echo.

REM Test 5: Config file content
echo [TEST 5] Checking config.ini content...
if exist "config.ini" (
    findstr "BOT_TOKEN" config.ini >nul 2>&1
    if errorlevel 1 (
        echo [FAIL] BOT_TOKEN not found in config.ini
    ) else (
        echo [PASS] BOT_TOKEN found
    )
    
    findstr "ADMIN_ID" config.ini >nul 2>&1
    if errorlevel 1 (
        echo [FAIL] ADMIN_ID not found in config.ini
    ) else (
        echo [PASS] ADMIN_ID found
    )
) else (
    echo [SKIP] config.ini not found
)
echo.

REM Test 6: Quick server test
echo [TEST 6] Quick server test...
echo [INFO] Starting WebApp server for 10 seconds...
start /min "Test Server" cmd /c "python scr\app\app.py"
timeout /t 5 /nobreak >nul

echo [INFO] Testing server response...
curl -s http://localhost:8080 >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Server not responding on localhost:8080
    echo [INFO] Check if app.py started without errors
) else (
    echo [PASS] Server responding on localhost:8080
)

echo [INFO] Stopping test server...
taskkill /f /im python.exe >nul 2>&1
echo.

echo ==========================================
echo              Test Complete
echo ==========================================
echo.
echo If all tests passed, try:
echo   run_local_fixed.bat     - for local testing
echo   run_with_tuna_fixed.bat - for public access
echo.
echo If tests failed, check the error messages above
echo.

:end
pause