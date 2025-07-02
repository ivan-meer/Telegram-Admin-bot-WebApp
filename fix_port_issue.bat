@echo off
chcp 65001 >nul 2>&1
title Fix Port 8080 Issue

echo ==========================================
echo        Fix Port 8080 Issue
echo ==========================================
echo.

echo [INFO] Checking what's using port 8080...
netstat -ano | findstr ":8080"

echo.
echo [INFO] Processes using port 8080:
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080"') do (
    if not "%%a"=="0" (
        echo PID: %%a
        tasklist /fi "PID eq %%a" /fo table 2>nul | findstr /v "INFO:"
    )
)

echo.
echo What would you like to do?
echo.
echo 1. Kill processes using port 8080 (recommended)
echo 2. Use alternative port 8081
echo 3. Show detailed port information
echo 4. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto kill_processes
if "%choice%"=="2" goto use_alt_port
if "%choice%"=="3" goto show_details
if "%choice%"=="4" goto end

:kill_processes
echo.
echo [INFO] Killing processes on port 8080...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080"') do (
    if not "%%a"=="0" (
        echo Killing PID: %%a
        taskkill /f /pid %%a 2>nul
    )
)

echo [INFO] Waiting 3 seconds...
timeout /t 3 /nobreak >nul

echo [INFO] Checking port 8080 again...
netstat -ano | findstr ":8080"
if errorlevel 1 (
    echo [SUCCESS] Port 8080 is now free!
    echo [INFO] You can now run: run_local_fixed.bat
) else (
    echo [WARNING] Port 8080 still in use
    echo [INFO] Try option 2 to use alternative port
)
goto end

:use_alt_port
echo.
echo [INFO] Configuring to use port 8081 instead...

REM Update app.py to use port 8081
python -c "
import re
with open('scr/app/app.py', 'r', encoding='utf-8') as f:
    content = f.read()
content = re.sub(r'port=8080', 'port=8081', content)
with open('scr/app/app.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('[OK] Updated app.py to use port 8081')
"

REM Update run_all.py if it exists
if exist "run_all.py" (
    python -c "
import re
with open('run_all.py', 'r', encoding='utf-8') as f:
    content = f.read()
content = re.sub(r'8080', '8081', content)
with open('run_all.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('[OK] Updated run_all.py to use port 8081')
    "
)

echo [INFO] Now update WebApp URL to use port 8081...
python update_webapp_url_windows.py http://localhost:8081

echo [SUCCESS] Configuration updated to use port 8081
echo [INFO] You can now run: run_local_fixed.bat
goto end

:show_details
echo.
echo [INFO] Detailed port information:
netstat -anob | findstr ":8080"
echo.
echo [INFO] All listening ports:
netstat -an | findstr "LISTENING" | findstr ":80"
goto end

:end
echo.
pause