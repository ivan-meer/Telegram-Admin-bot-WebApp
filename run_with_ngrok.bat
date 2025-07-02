@echo off
echo 🌐 Запуск WebApp с ngrok туннелем
echo ==================================

REM Проверяем наличие ngrok
ngrok version >nul 2>&1
if errorlevel 1 (
    echo ❌ ngrok не найден!
    echo.
    echo 📥 Инструкция по установке ngrok:
    echo    1. Перейдите на https://ngrok.com/download
    echo    2. Скачайте ngrok для Windows
    echo    3. Распакуйте ngrok.exe в папку проекта или добавьте в PATH
    echo    4. Зарегистрируйтесь на ngrok.com
    echo    5. Выполните: ngrok authtoken YOUR_TOKEN
    echo.
    pause
    exit /b 1
)

echo ✅ ngrok найден

REM Запускаем WebApp сервер
echo 🔧 Запуск WebApp сервера...
start "WebApp Server" cmd /k "echo WebApp Server && python scr/app/app.py"
timeout /t 3 /nobreak

REM Запускаем ngrok туннель
echo 🔧 Запуск ngrok туннеля...
start "Ngrok Tunnel" cmd /k "echo Ngrok Tunnel && ngrok http 8080"
timeout /t 5 /nobreak

echo.
echo ⏳ Ожидание инициализации ngrok...
timeout /t 5 /nobreak

REM Пытаемся получить ngrok URL
echo 🔍 Получение ngrok URL...
for /f "tokens=*" %%i in ('curl -s http://localhost:4040/api/tunnels 2^>nul') do set NGROK_RESPONSE=%%i

if "%NGROK_RESPONSE%"=="" (
    echo ⚠️ Не удалось автоматически получить ngrok URL
    echo 📋 Вручную:
    echo    1. Откройте http://localhost:4040 в браузере
    echo    2. Скопируйте https URL из ngrok dashboard
    echo    3. Выполните: python update_webapp_url_windows.py HTTPS_URL
    echo.
) else (
    echo ✅ ngrok запущен, проверьте dashboard: http://localhost:4040
)

REM Запускаем остальные сервисы
echo 🔧 Запуск Telegram бота...
start "Telegram Bot" cmd /k "echo Telegram Bot && python scr/bot/bot.py"
timeout /t 2 /nobreak

echo 🔧 Запуск парсера...
start "Parser" cmd /k "echo Parser && python scr/parser/parser.py"

echo.
echo ✅ Все сервисы запущены!
echo.
echo 📋 Следующие шаги:
echo    1. Откройте http://localhost:4040 в браузере
echo    2. Скопируйте HTTPS URL (например: https://abc123.ngrok.io)
echo    3. Выполните: python update_webapp_url_windows.py ВАША_NGROK_URL
echo    4. Перезапустите бота: python scr/bot/bot.py
echo    5. Отправьте /start боту в личные сообщения
echo.
echo ⏹️ Нажмите любую клавишу для остановки...
pause >nul

REM Закрываем все процессы
echo 🛑 Остановка сервисов...
taskkill /f /im python.exe 2>nul
taskkill /f /im ngrok.exe 2>nul
echo ✅ Все сервисы остановлены
pause