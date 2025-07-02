#!/usr/bin/env python3
"""
Скрипт для настройки ngrok туннеля для WebApp
Требует предварительной установки ngrok: https://ngrok.com/download
"""

import subprocess
import time
import threading
import requests
import json
from pathlib import Path

def start_webapp_server():
    """Запуск FastAPI сервера"""
    try:
        subprocess.run([
            "python3", "-m", "uvicorn", 
            "scr.app.app:app", 
            "--host", "0.0.0.0", 
            "--port", "8080"
        ], cwd=Path.cwd())
    except Exception as e:
        print(f"Ошибка запуска сервера: {e}")

def start_ngrok_tunnel():
    """Запуск ngrok туннеля"""
    try:
        # Запускаем ngrok для порта 8080
        process = subprocess.Popen([
            "ngrok", "http", "8080"
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        print("Запуск ngrok туннеля...")
        time.sleep(3)  # Даем время ngrok запуститься
        
        # Получаем публичный URL
        try:
            response = requests.get("http://localhost:4040/api/tunnels")
            data = response.json()
            
            if data["tunnels"]:
                public_url = data["tunnels"][0]["public_url"]
                print(f"\n🚀 WebApp доступен по адресу: {public_url}")
                print(f"📝 Обновите config.ini или код с этим URL")
                
                # Сохраняем URL в файл
                with open("webapp_url.txt", "w") as f:
                    f.write(public_url)
                    
                return public_url
            
        except Exception as e:
            print(f"Не удалось получить ngrok URL: {e}")
            
        return None
        
    except FileNotFoundError:
        print("❌ ngrok не найден!")
        print("📥 Установите ngrok:")
        print("   1. Скачайте с https://ngrok.com/download")
        print("   2. Распакуйте в /usr/local/bin/ или добавьте в PATH")
        print("   3. Зарегистрируйтесь и получите authtoken")
        print("   4. Выполните: ngrok authtoken YOUR_TOKEN")
        return None
        
    except Exception as e:
        print(f"Ошибка запуска ngrok: {e}")
        return None

def main():
    print("🔧 Настройка WebApp с ngrok туннелем")
    print("=" * 50)
    
    # Проверяем доступность ngrok
    try:
        result = subprocess.run(["ngrok", "version"], 
                              capture_output=True, text=True)
        print(f"✅ ngrok установлен: {result.stdout.strip()}")
    except FileNotFoundError:
        print("❌ ngrok не установлен!")
        print("\n📋 Инструкция по установке:")
        print("1. Перейдите на https://ngrok.com/download")
        print("2. Скачайте версию для Linux")
        print("3. Распакуйте: unzip ngrok-v3-stable-linux-amd64.zip")
        print("4. Переместите: sudo mv ngrok /usr/local/bin/")
        print("5. Зарегистрируйтесь на ngrok.com и получите authtoken")
        print("6. Авторизуйтесь: ngrok authtoken YOUR_TOKEN")
        return
    
    # Запускаем сервер в отдельном потоке
    server_thread = threading.Thread(target=start_webapp_server, daemon=True)
    server_thread.start()
    
    print("⏳ Запуск FastAPI сервера...")
    time.sleep(2)
    
    # Запускаем ngrok туннель
    public_url = start_ngrok_tunnel()
    
    if public_url:
        print(f"\n✅ Туннель создан успешно!")
        print(f"📱 Обновите WebApp URL в коде:")
        print(f"   webapp_url = \"{public_url}\"")
        print(f"\n💡 Для автоматического обновления URL в конфиге:")
        print(f"   python3 update_webapp_url.py {public_url}")
        
        # Держим туннель открытым
        try:
            while True:
                time.sleep(60)
                print("🔄 Туннель активен...")
        except KeyboardInterrupt:
            print("\n👋 Остановка туннеля...")
    else:
        print("❌ Не удалось создать туннель")

if __name__ == "__main__":
    main()