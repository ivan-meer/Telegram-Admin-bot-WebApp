@echo off
chcp 65001 >nul 2>&1
title TeleHub Bot

echo ==========================================
echo           TeleHub Bot Launcher
echo ==========================================
echo.

REM Set PYTHONPATH to include project root
set PYTHONPATH=%CD%;%PYTHONPATH%
echo [INFO] Python path set to: %CD%

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

REM Check config
if not exist "config.ini" (
    echo [ERROR] config.ini not found!
    echo [INFO] Create config.ini with bot settings
    pause
    exit /b 1
)

echo [INFO] Starting Telegram Bot...
echo [INFO] Press Ctrl+C to stop
echo.

REM Change to project root and run bot
cd /d "%~dp0"
python -m scr.bot.bot

if errorlevel 1 (
    echo.
    echo [ERROR] Bot failed to start!
    echo [INFO] Common issues:
    echo   - Check BOT_TOKEN in config.ini
    echo   - Check ADMIN_ID in config.ini  
    echo   - Ensure bot token is valid
    echo   - Check internet connection
    echo.
    pause
)