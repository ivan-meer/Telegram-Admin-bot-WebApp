#!/usr/bin/env python3
"""
Скрипт для автоматического обновления WebApp URL в коде
Использование: python3 update_webapp_url.py https://your-ngrok-url.com
"""

import sys
import re
from pathlib import Path

def update_keyboard_url(new_url):
    """Обновляем URL в keyboard.py"""
    keyboard_file = Path("scr/bot/keyboard/keyboard.py")
    
    if not keyboard_file.exists():
        print(f"❌ Файл {keyboard_file} не найден")
        return False
    
    # Читаем файл
    content = keyboard_file.read_text(encoding='utf-8')
    
    # Заменяем URL
    pattern = r'webapp_url = "[^"]*"'
    replacement = f'webapp_url = "{new_url}"'
    
    updated_content = re.sub(pattern, replacement, content)
    
    # Проверяем, была ли замена
    if updated_content != content:
        keyboard_file.write_text(updated_content, encoding='utf-8')
        print(f"✅ URL обновлен в {keyboard_file}")
        return True
    else:
        print(f"⚠️ URL не найден для замены в {keyboard_file}")
        return False

def update_config_ini(new_url):
    """Добавляем секцию WEBAPP в config.ini"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print(f"❌ Файл {config_file} не найден")
        return False
    
    # Читаем файл
    content = config_file.read_text(encoding='utf-8')
    
    # Проверяем, есть ли уже секция WEBAPP
    if "[WEBAPP]" in content:
        # Заменяем существующий URL
        pattern = r'\[WEBAPP\].*?WEBAPP_URL = [^\r\n]*'
        replacement = f'[WEBAPP]\nWEBAPP_URL = {new_url}'
        updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    else:
        # Добавляем новую секцию
        updated_content = content + f"\n\n[WEBAPP]\nWEBAPP_URL = {new_url}\n"
    
    config_file.write_text(updated_content, encoding='utf-8')
    print(f"✅ URL добавлен в {config_file}")
    return True

def main():
    if len(sys.argv) != 2:
        print("❌ Использование: python3 update_webapp_url.py <URL>")
        print("   Пример: python3 update_webapp_url.py https://abc123.ngrok.io")
        sys.exit(1)
    
    new_url = sys.argv[1]
    
    # Валидация URL
    if not (new_url.startswith('http://') or new_url.startswith('https://')):
        print("❌ URL должен начинаться с http:// или https://")
        sys.exit(1)
    
    print(f"🔄 Обновление WebApp URL на: {new_url}")
    print("=" * 50)
    
    # Обновляем файлы
    keyboard_updated = update_keyboard_url(new_url)
    config_updated = update_config_ini(new_url)
    
    if keyboard_updated or config_updated:
        print("\n✅ URL успешно обновлен!")
        print("🔄 Перезапустите бота для применения изменений")
        print("   python3 scr/bot/bot.py")
    else:
        print("\n❌ Не удалось обновить URL")

if __name__ == "__main__":
    main()