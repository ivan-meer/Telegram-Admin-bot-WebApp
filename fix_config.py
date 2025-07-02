#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Fix config.ini by removing inline comments
"""

import configparser
import shutil
from pathlib import Path

def fix_config_ini():
    """Clean up config.ini by removing inline comments"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print("[ERROR] config.ini not found!")
        return False
    
    # Backup original file
    backup_file = Path("config.ini.backup")
    shutil.copy2(config_file, backup_file)
    print(f"[INFO] Backup created: {backup_file}")
    
    try:
        # Read config manually to preserve structure
        with open(config_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Clean up lines
        cleaned_lines = []
        for line in lines:
            # If line contains a value assignment, clean it
            if '=' in line and not line.strip().startswith('#'):
                key_value = line.split('=', 1)
                if len(key_value) == 2:
                    key = key_value[0].strip()
                    value = key_value[1].split('#')[0].strip()  # Remove inline comments
                    cleaned_lines.append(f"{key} = {value}\n")
                else:
                    cleaned_lines.append(line)
            else:
                # Keep section headers and comments as is
                cleaned_lines.append(line)
        
        # Write cleaned config
        with open(config_file, 'w', encoding='utf-8') as f:
            f.writelines(cleaned_lines)
        
        print("[SUCCESS] config.ini cleaned successfully!")
        
        # Verify the cleaned config
        config = configparser.ConfigParser()
        config.read(config_file, encoding='utf-8')
        
        # Test ADMIN_ID parsing
        try:
            admin_id = int(config.get('ADMIN', 'ADMIN_ID'))
            print(f"[VERIFY] ADMIN_ID parsed successfully: {admin_id}")
        except Exception as e:
            print(f"[ERROR] ADMIN_ID still has issues: {e}")
            return False
        
        # Test BOT_TOKEN
        try:
            bot_token = config.get('BOT_TOKEN', 'BOT_TOKEN')
            if bot_token and len(bot_token) > 10:
                print("[VERIFY] BOT_TOKEN looks valid")
            else:
                print("[WARNING] BOT_TOKEN might be missing or invalid")
        except Exception as e:
            print(f"[WARNING] BOT_TOKEN issue: {e}")
        
        return True
        
    except Exception as e:
        print(f"[ERROR] Failed to fix config.ini: {e}")
        # Restore backup
        shutil.copy2(backup_file, config_file)
        print("[INFO] Restored original config from backup")
        return False

def show_config_content():
    """Show current config content for verification"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print("[ERROR] config.ini not found!")
        return
    
    print("\n[INFO] Current config.ini content:")
    print("=" * 40)
    
    try:
        with open(config_file, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f.readlines(), 1):
                print(f"{i:2d}: {line.rstrip()}")
    except Exception as e:
        print(f"[ERROR] Could not read config.ini: {e}")

if __name__ == "__main__":
    print("Config.ini Fixer Tool")
    print("=" * 30)
    
    show_config_content()
    
    print(f"\n[INFO] Fixing config.ini...")
    if fix_config_ini():
        print("\n[SUCCESS] Config fixed! You can now run the bot.")
        print("Try: run_bot_fixed.bat")
    else:
        print("\n[FAIL] Could not fix config. Please check manually.")
        
    print(f"\nAfter fix:")
    show_config_content()