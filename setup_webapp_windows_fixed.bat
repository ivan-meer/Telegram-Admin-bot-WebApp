@echo off
chcp 65001 >nul 2>&1
title TeleHub WebApp Setup

echo ==========================================
echo       TeleHub WebApp Setup for Windows
echo ==========================================
echo.

REM Check Python
echo [1/4] Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    echo [INFO] Please install Python 3.10+ from python.org
    echo.
    pause
    exit /b 1
)

python --version
echo [OK] Python found
echo.

REM Install dependencies
echo [2/4] Installing dependencies...
if exist "requirements.txt" (
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [WARNING] Some packages failed to install
        echo [INFO] Try: python -m pip install --upgrade pip
    ) else (
        echo [OK] Dependencies installed
    )
) else (
    echo [WARNING] requirements.txt not found, skipping...
)
echo.

REM Check config.ini
echo [3/4] Checking configuration...
if not exist "config.ini" (
    echo [ERROR] config.ini not found!
    echo [INFO] Please create config.ini with your bot settings
    echo [INFO] Copy from config.ini.example if available
    echo.
    pause
    exit /b 1
)

echo [OK] config.ini found
echo.

REM Show IP addresses
echo [4/4] Network information:
echo Local IP addresses:
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do (
    for /f "tokens=1" %%j in ("%%i") do echo   - %%j
)
echo.

echo ==========================================
echo             Setup Complete!
echo ==========================================
echo.
echo Choose your launch method:
echo   1. Local testing    - run_local_fixed.bat
echo   2. With tuna.exe    - run_with_tuna_fixed.bat  
echo   3. With ngrok       - run_with_ngrok_fixed.bat
echo.
echo To start now, run one of the batch files above
echo.
pause