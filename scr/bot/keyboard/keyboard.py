from aiogram.types import InlineKeyboardMarkup, InlineKeyboardButton, WebAppInfo
import sys
import os

# Add project root to Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))))

try:
    from scr.bot.system.dispatcher import config
except ImportError:
    # Fallback: try relative import
    try:
        from ..system.dispatcher import config
    except ImportError:
        # Last resort: try direct import
        import configparser
        config = configparser.ConfigParser()
        config.read('config.ini', encoding='utf-8')


def create_admin_panel_keyboard(user_id: int) -> InlineKeyboardMarkup:
    """Клавиатура для главного меню (с проверкой ID)"""
    buttons = []

    # Получаем ADMIN_ID из конфига вместо захардкоженного значения
    try:
        admin_id_str = config.get('ADMIN', 'ADMIN_ID')
        # Убираем комментарии после значения
        admin_id_str = admin_id_str.split('#')[0].strip()
        admin_id = int(admin_id_str)
    except (ValueError, TypeError) as e:
        print(f"[ERROR] Invalid ADMIN_ID in config.ini: {e}")
        # Fallback to a safe default (will not match any real user)
        admin_id = -1
    
    # Показываем кнопку только если ID совпадает
    if user_id == admin_id:
        # Получаем URL из конфига
        try:
            webapp_url = config.get('WEBAPP', 'WEBAPP_URL')
        except:
            # Fallback если секция не найдена
            webapp_url = "http://localhost:8080"
        
        buttons.append(
            [
                InlineKeyboardButton(
                    text="Панель администратора",
                    web_app=WebAppInfo(url=webapp_url),
                )
            ]
        )

    return InlineKeyboardMarkup(inline_keyboard=buttons)
