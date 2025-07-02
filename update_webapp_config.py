#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script for updating WebApp URL in config.ini
Usage: python update_webapp_config.py https://your-url.com
"""

import sys
import configparser
from pathlib import Path

# Fix encoding for Windows console
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.detach())
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.detach())

def update_config_webapp_url(new_url):
    """Update WEBAPP_URL in config.ini"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print(f"[ERROR] config.ini not found!")
        return False
    
    try:
        # Read config
        config = configparser.ConfigParser()
        config.read(config_file, encoding='utf-8')
        
        # Ensure WEBAPP section exists
        if 'WEBAPP' not in config:
            config.add_section('WEBAPP')
        
        # Update URL
        config.set('WEBAPP', 'WEBAPP_URL', new_url)
        
        # Write back to file
        with open(config_file, 'w', encoding='utf-8') as f:
            config.write(f)
        
        print(f"[OK] WebApp URL updated in config.ini: {new_url}")
        return True
        
    except Exception as e:
        print(f"[ERROR] Failed to update config.ini: {e}")
        return False

def show_current_config():
    """Show current config.ini content"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print("[ERROR] config.ini not found!")
        return
    
    try:
        config = configparser.ConfigParser()
        config.read(config_file, encoding='utf-8')
        
        print("\n[INFO] Current config.ini settings:")
        print("=" * 40)
        
        for section_name in config.sections():
            print(f"[{section_name}]")
            for key, value in config.items(section_name):
                # Hide sensitive values
                if 'token' in key.lower() or 'password' in key.lower() or 'hash' in key.lower():
                    print(f"  {key} = ***HIDDEN***")
                else:
                    print(f"  {key} = {value}")
            print()
            
    except Exception as e:
        print(f"[ERROR] Failed to read config.ini: {e}")

def main():
    print("WebApp URL Configuration Tool")
    print("=" * 40)
    
    if len(sys.argv) == 1:
        print("Usage options:")
        print("  python update_webapp_config.py <URL>        - Update WebApp URL")
        print("  python update_webapp_config.py --show       - Show current config")
        print("")
        print("Examples:")
        print("  python update_webapp_config.py http://localhost:8080")
        print("  python update_webapp_config.py https://abc123.ngrok.io")
        print("  python update_webapp_config.py https://mybotadmin.ru.tuna.am")
        show_current_config()
        return
    
    if sys.argv[1] == '--show':
        show_current_config()
        return
    
    new_url = sys.argv[1]
    
    # Validate URL
    if not (new_url.startswith('http://') or new_url.startswith('https://')):
        print("[ERROR] URL must start with http:// or https://")
        return
    
    print(f"[INFO] Updating WebApp URL to: {new_url}")
    
    if update_config_webapp_url(new_url):
        print("\n[SUCCESS] Configuration updated!")
        print(f"[INFO] WebApp URL: {new_url}")
        print("\n[NEXT STEPS]")
        print("1. Restart your bot: python scr/bot/bot.py")
        print("2. Send /start to your bot in Telegram")
        print("3. Click 'Admin Panel' button")
        
        # Show if it's local or public URL
        if "localhost" in new_url or "127.0.0.1" in new_url or "192.168" in new_url:
            print("\n[NOTE] This is a local URL - accessible only from your network")
        else:
            print("\n[NOTE] This is a public URL - accessible from internet")
            
    else:
        print("\n[FAIL] Failed to update configuration")

if __name__ == "__main__":
    main()