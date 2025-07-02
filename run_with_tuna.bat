@echo off
echo 🌐 Запуск WebApp с tuna.exe туннелем
echo =====================================

REM Проверяем наличие tuna.exe
if not exist "tuna.exe" (
    echo ❌ tuna.exe не найден!
    echo 📥 Скачайте tuna.exe и поместите в папку проекта
    pause
    exit /b 1
)

echo ✅ tuna.exe найден

REM Обновляем URL для tuna туннеля
echo 🔄 Настройка URL для tuna туннеля...
python update_webapp_url_windows.py https://mybotadmin.ru.tuna.am

echo.
echo 📱 Настройки:
echo    WebApp URL: https://mybotadmin.ru.tuna.am
echo    Публичный доступ через tuna туннель
echo.

REM Запускаем сервисы по очереди
echo 🔧 Запуск WebApp сервера...
start "WebApp Server" cmd /k "echo WebApp Server && python scr/app/app.py"
timeout /t 3 /nobreak

echo 🔧 Запуск Telegram бота...
start "Telegram Bot" cmd /k "echo Telegram Bot && python scr/bot/bot.py"
timeout /t 3 /nobreak

echo 🔧 Запуск парсера...
start "Parser" cmd /k "echo Parser && python scr/parser/parser.py"
timeout /t 3 /nobreak

echo 🔧 Запуск tuna туннеля...
start "Tuna Tunnel" cmd /k "echo Tuna Tunnel && tuna http 8080 --subdomain=mybotadmin"

echo.
echo ✅ Все сервисы запущены!
echo 📱 Отправьте /start боту в личные сообщения
echo 🌐 WebApp: https://mybotadmin.ru.tuna.am
echo.
echo ⚠️ Если WebApp не открывается:
echo    1. Проверьте, что все окна запустились без ошибок
echo    2. Подождите 1-2 минуты для инициализации туннеля
echo    3. Убедитесь, что порт 8080 свободен
echo.
echo ⏹️ Нажмите любую клавишу для остановки...
pause >nul

REM Закрываем все процессы
echo 🛑 Остановка сервисов...
taskkill /f /im python.exe 2>nul
taskkill /f /im tuna.exe 2>nul
echo ✅ Все сервисы остановлены
pause