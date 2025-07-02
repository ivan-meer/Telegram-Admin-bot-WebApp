#!/usr/bin/env python3
"""
Simple script to update the webapp URL in config.ini with the ngrok URL
Usage: python update_ngrok_url.py YOUR_NGROK_HTTPS_URL
"""

import sys
import configparser
from pathlib import Path

def update_webapp_url(ngrok_url):
    """Update the WEBAPP_URL in config.ini"""
    config_file = Path("config.ini")
    
    if not config_file.exists():
        print("❌ config.ini not found!")
        return False
    
    # Read the config
    config = configparser.ConfigParser()
    config.read(config_file)
    
    # Update the WEBAPP section
    if 'WEBAPP' not in config:
        config.add_section('WEBAPP')
    
    config['WEBAPP']['WEBAPP_URL'] = ngrok_url
    
    # Write back to file
    with open(config_file, 'w') as f:
        config.write(f)
    
    print(f"✅ Updated WEBAPP_URL to: {ngrok_url}")
    print("📝 Config updated successfully!")
    return True

def main():
    if len(sys.argv) != 2:
        print("Usage: python update_ngrok_url.py YOUR_NGROK_HTTPS_URL")
        print("Example: python update_ngrok_url.py https://abc123-def456.ngrok-free.app")
        return
    
    ngrok_url = sys.argv[1].strip()
    
    if not ngrok_url.startswith('https://'):
        print("❌ Please provide an HTTPS URL from ngrok")
        return
    
    if update_webapp_url(ngrok_url):
        print("\n🎉 Next steps:")
        print("1. Restart your Telegram bot if it's running")
        print("2. Test the webapp by sending /start to your bot")
        print("3. The Mini-App should now be accessible!")

if __name__ == "__main__":
    main()
