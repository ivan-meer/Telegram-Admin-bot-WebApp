#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script for updating WebApp URL in code (Windows version)
Usage: python update_webapp_url_windows.py https://your-url.com
"""

import sys
import re
import os
from pathlib import Path

# Fix encoding for Windows console
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.detach())
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.detach())

def update_keyboard_url(new_url):
    """Обновляем URL в keyboard.py"""
    keyboard_file = Path("scr/bot/keyboard/keyboard.py")
    
    if not keyboard_file.exists():
        print(f"❌ Файл {keyboard_file} не найден")
        return False
    
    try:
        # Читаем файл
        with open(keyboard_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Заменяем URL
        pattern = r'webapp_url = "[^"]*"'
        replacement = f'webapp_url = "{new_url}"'
        
        updated_content = re.sub(pattern, replacement, content)
        
        # Проверяем, была ли замена
        if updated_content != content:
            with open(keyboard_file, 'w', encoding='utf-8') as f:
                f.write(updated_content)
            print(f"[OK] URL updated in {keyboard_file}")
            return True
        else:
            print(f"[WARNING] URL pattern not found in {keyboard_file}")
            # Если не найден старый URL, ищем место для вставки
            if "web_app=WebAppInfo(url=" in content:
                pattern = r'web_app=WebAppInfo\(url="[^"]*"\)'
                replacement = f'web_app=WebAppInfo(url="{new_url}")'
                updated_content = re.sub(pattern, replacement, content)
                
                with open(keyboard_file, 'w', encoding='utf-8') as f:
                    f.write(updated_content)
                print(f"[OK] URL updated in WebAppInfo in {keyboard_file}")
                return True
            return False
            
    except Exception as e:
        print(f"[ERROR] Failed to update {keyboard_file}: {e}")
        return False

def update_config_ini(new_url):
    """Добавляем секцию WEBAPP в config.ini"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print(f"❌ Файл {config_file} не найден")
        return False
    
    try:
        # Читаем файл
        with open(config_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Проверяем, есть ли уже секция WEBAPP
        if "[WEBAPP]" in content:
            # Заменяем существующий URL
            pattern = r'\[WEBAPP\].*?WEBAPP_URL = [^\r\n]*'
            replacement = f'[WEBAPP]\nWEBAPP_URL = {new_url}'
            updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
        else:
            # Добавляем новую секцию
            updated_content = content + f"\n\n[WEBAPP]\nWEBAPP_URL = {new_url}\n"
        
        with open(config_file, 'w', encoding='utf-8') as f:
            f.write(updated_content)
        print(f"✅ URL добавлен в {config_file}")
        return True
        
    except Exception as e:
        print(f"❌ Ошибка при обновлении {config_file}: {e}")
        return False

def main():
    if len(sys.argv) != 2:
        print("❌ Использование: python update_webapp_url_windows.py <URL>")
        print("   Пример: python update_webapp_url_windows.py https://abc123.ngrok.io")
        print("   Или: python update_webapp_url_windows.py http://192.168.1.100:8080")
        input("Нажмите Enter для выхода...")
        sys.exit(1)
    
    new_url = sys.argv[1]
    
    # Валидация URL
    if not (new_url.startswith('http://') or new_url.startswith('https://')):
        print("❌ URL должен начинаться с http:// или https://")
        input("Нажмите Enter для выхода...")
        sys.exit(1)
    
    print(f"🔄 Обновление WebApp URL на: {new_url}")
    print("=" * 50)
    
    # Обновляем файлы
    keyboard_updated = update_keyboard_url(new_url)
    config_updated = update_config_ini(new_url)
    
    if keyboard_updated or config_updated:
        print("\n✅ URL успешно обновлен!")
        print("🔄 Перезапустите бота для применения изменений")
        print("   Используйте run_with_tuna.bat или run_local.bat")
    else:
        print("\n❌ Не удалось обновить URL")
        print("🔍 Проверьте содержимое файлов вручную")
    
    print("\n📋 Текущие настройки:")
    print(f"   WebApp URL: {new_url}")
    
    # Показываем инструкции
    if "localhost" in new_url or "127.0.0.1" in new_url or "192.168" in new_url:
        print("\n📱 Локальное тестирование:")
        print("   - Работает только в вашей локальной сети")
        print("   - Для публичного доступа используйте tuna.exe или ngrok")
    else:
        print("\n🌐 Публичный доступ:")
        print("   - WebApp доступен из интернета")
        print("   - Убедитесь, что туннель активен")

if __name__ == "__main__":
    main()