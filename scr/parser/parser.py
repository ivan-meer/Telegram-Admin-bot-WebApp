# -*- coding: utf-8 -*-
import asyncio
from loguru import logger
from telethon import TelegramClient, events
from telethon.errors import UserAlreadyParticipantError
from telethon.tl.functions.channels import JoinChannelRequest
from telethon.tl.types import Message

from scr.bot.system.dispatcher import api_id, api_hash

# ⚙️ Конфигурация
CONFIG = {
    "source_channels": ["@tehnik_shanel", "@hdgdhsvsvs"],
    "target_channel_id": -1001918436153,
    "keywords": ["киевский район"],
    "session_name": "scr/setting/session_name"
}

# 🧠 Простейший трекер сообщений (в памяти)
forwarded_messages = set()


async def process_message(client, message: Message, chat_id: int):
    if not message.message:
        return

    message_text = message.message.lower()
    msg_key = f"{chat_id}-{message.id}"

    if msg_key in forwarded_messages:
        return

    if any(keyword in message_text for keyword in CONFIG["keywords"]):
        logger.info(f"📌 Найдено совпадение. Пересылаю сообщение ID={message.id}")
        try:
            await client.forward_messages(CONFIG["target_channel_id"], message)
            forwarded_messages.add(msg_key)
        except Exception as e:
            logger.error(f"❌ Ошибка при пересылке: {e}")


async def join_required_channels(client: TelegramClient):
    for channel in CONFIG["source_channels"]:
        try:
            logger.info(f"🔗 Пробую подписаться на {channel}...")
            await client(JoinChannelRequest(channel))
            logger.success(f"✅ Подписка на {channel} выполнена")
        except UserAlreadyParticipantError:
            logger.info(f"ℹ️ Уже подписан на {channel}")
        except Exception as e:
            logger.error(f"❌ Не удалось подписаться на {channel}: {e}")


async def filter_messages():
    logger.info("🚀 Запуск бота...")

    client = TelegramClient(CONFIG["session_name"], api_id, api_hash)
    await client.connect()

    await join_required_channels(client)

    @client.on(events.NewMessage(chats=CONFIG["source_channels"]))
    async def handle_new_message(event: events.NewMessage.Event):
        await process_message(client, event.message, event.chat_id)

    logger.info("👂 Бот слушает новые сообщения...")
    try:
        await client.run_until_disconnected()
    finally:
        await client.disconnect()
        logger.info("🛑 Бот остановлен.")


def parser():
    try:
        asyncio.run(filter_messages())
    except KeyboardInterrupt:
        logger.warning("🧹 Остановка по Ctrl+C")


if __name__ == "__main__":
    parser()
