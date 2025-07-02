@echo off
echo 🚀 Запуск WebApp локально (для тестирования)
echo ===============================================

REM Получаем локальный IP
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4" ^| findstr "192.168"') do set LOCAL_IP=%%i
set LOCAL_IP=%LOCAL_IP: =%

if "%LOCAL_IP%"=="" (
    set LOCAL_IP=localhost
    echo ⚠️ Не удалось определить IP, используем localhost
) else (
    echo 💻 Локальный IP: %LOCAL_IP%
)

REM Обновляем URL в коде
echo 🔄 Обновление URL в коде...
python update_webapp_url_windows.py http://%LOCAL_IP%:8080

echo.
echo 📱 Настройки:
echo    WebApp URL: http://%LOCAL_IP%:8080
echo    Доступ только из локальной сети
echo.

REM Запускаем все сервисы
echo 🔧 Запуск сервисов...
start "WebApp Server" cmd /k "python scr/app/app.py"
timeout /t 3 /nobreak

start "Telegram Bot" cmd /k "python scr/bot/bot.py"

echo.
echo ✅ Сервисы запущены!
echo 📱 Отправьте /start боту в личные сообщения
echo 🌐 WebApp: http://%LOCAL_IP%:8080
echo.
echo ⏹️ Нажмите любую клавишу для остановки...
pause >nul

REM Закрываем окна
taskkill /f /im python.exe 2>nul
echo 🛑 Сервисы остановлены
pause