@echo off
chcp 65001 >nul
echo Setting up WebApp for Windows
echo =====================================

REM Проверяем Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found! Install Python 3.10+
    pause
    exit /b 1
)

echo [OK] Python found

REM Устанавливаем зависимости
echo [INFO] Installing dependencies...
pip install -r requirements.txt

REM Проверяем config.ini
if not exist "config.ini" (
    echo [ERROR] config.ini file not found!
    echo [INFO] Create config.ini with bot settings
    pause
    exit /b 1
)

echo [OK] config.ini found

REM Показываем текущий IP
echo [INFO] Your local IP address:
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do echo %%i

echo.
echo 🚀 Готово к запуску!
echo.
echo 📋 Выберите способ запуска:
echo    1. Локальное тестирование (run_local.bat)
echo    2. С tuna.exe туннелем (run_with_tuna.bat)
echo    3. С ngrok туннелем (run_with_ngrok.bat)
echo.
pause