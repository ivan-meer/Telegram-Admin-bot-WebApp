# 🚀 TeleHub v2.0 - Telegram Mini-App Community Manager

**Современный центр управления Telegram-сообществами через Mini-App**

<div align="center">
  <img src="doc/TGAdminWebApp.png" alt="TeleHub" width="600">
</div>

---

## 📋 О проекте

TeleHub v2.0 - это упрощенная и эффективная версия Telegram Mini-App для управления каналами и групп. Проект переосмыслен с фокусом на **простоту, скорость и пользовательский опыт**.

### 🎯 Ключевые принципы:
- **Простота превыше всего** - максимум пользы с минимумом сложности
- **Mobile-first** - оптимизация для мобильных устройств  
- **Быстрый TTM** - фокус на скорейший выход MVP
- **Итеративность** - поэтапное добавление функций

---

## 🏗️ Архитектура проекта

```
TeleHub v2.0/
├── frontend/           # React + TypeScript Mini-App
│   ├── src/
│   │   ├── components/ # Переиспользуемые компоненты
│   │   ├── pages/      # Страницы приложения
│   │   ├── hooks/      # React hooks
│   │   ├── services/   # API клиенты
│   │   ├── types/      # TypeScript типы
│   │   └── utils/      # Утилиты
├── backend/            # FastAPI + PostgreSQL
│   ├── app/           # FastAPI приложение
│   ├── models/        # Database models
│   ├── services/      # Бизнес-логика
│   └── utils/         # Утилиты
├── docker/            # Docker конфигурации
├── docs/              # Документация
└── .github/           # GitHub Actions
```

### 🛠️ Технологический стек:
- **Frontend**: React 18, TypeScript, Telegram WebApp SDK
- **Backend**: Python 3.11, FastAPI, SQLAlchemy, PostgreSQL
- **Cache**: Redis (сессии)
- **AI**: OpenAI API (прямая интеграция)
- **Deploy**: Docker + VPS
- **CI/CD**: GitHub Actions

---

## 🚀 Функциональность MVP

### Phase 1 (6 недель) - Основной функционал:

#### 📱 Unified Dashboard
- Список всех подключенных каналов/групп
- Карточки с быстрыми действиями
- Статус-индикаторы активности
- Поиск и фильтрация

#### 📺 Content Viewer
- Просмотр контента каналов через WebApp
- Навигация по топикам (для групп-форумов)
- Предпросмотр медиа-контента
- Быстрые действия: переслать, закрепить, удалить

#### ⚙️ Channel Management
- Добавление каналов/групп по @username
- Проверка прав доступа
- Настройки уведомлений
- Управление подключениями

#### 📊 Simple Analytics
- Прирост подписчиков
- Активность постов
- Лучшие посты за период
- Простые графики

### Phase 2 (4 недели) - Расширение:
- Smart Assistant (базовый AI)
- Расширенная аналитика
- Монетизация через Telegram Stars

---

## 🔧 Быстрый старт

### Требования:
- Node.js 18+
- Python 3.11+
- PostgreSQL 13+
- Redis 6+

### Запуск для разработки:

```bash
# Клонирование репозитория
git clone https://github.com/your-username/TeleHub-v2.git
cd TeleHub-v2

# Backend
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload

# Frontend
cd ../frontend
npm install
npm run dev

# Или с Docker
docker-compose up -d
```

### Конфигурация:

Создайте `.env` файл:
```env
# Telegram
BOT_TOKEN=your_bot_token
WEBHOOK_URL=https://your-domain.com/webhook

# Database
DATABASE_URL=postgresql://user:pass@localhost/telehub
REDIS_URL=redis://localhost:6379

# AI
OPENAI_API_KEY=your_openai_key
```

---

## 📊 Roadmap

### ✅ Q4 2024 - Подготовка
- [x] Анализ и переосмысление архитектуры
- [x] Создание улучшенного ТЗ
- [x] Настройка репозитория

### 🚧 Q1 2025 - Phase 1 MVP
- [ ] **Неделя 1-2**: Базовая архитектура + Dashboard
- [ ] **Неделя 3-4**: Content Viewer + Channel Management  
- [ ] **Неделя 5-6**: Analytics + тестирование

### 🔮 Q2 2025 - Phase 2
- [ ] **Неделя 7-8**: Smart Assistant (базовый)
- [ ] **Неделя 9-10**: Монетизация + полировка

### 🌟 Q3 2025 - Phase 3 (по запросу)
- [ ] Graph View (если будет спрос)
- [ ] Advanced AI Assistant
- [ ] Team collaboration
- [ ] Advanced analytics

---

## 💰 Монетизация

### 🆓 Free Tier:
- До 3 каналов/групп
- Базовая аналитика
- 50 AI запросов/месяц

### 💎 Premium ($9.99/месяц через Telegram Stars):
- Безлимитные каналы
- Расширенная аналитика
- 1000 AI запросов/месяц
- Приоритетная поддержка

---

## 🤝 Участие в разработке

Мы приветствуем вклад в развитие проекта!

1. Fork репозитория
2. Создайте feature branch
3. Сделайте изменения
4. Создайте Pull Request

### Структура коммитов:
```
feat: добавить новую функцию
fix: исправить баг
docs: обновить документацию
style: изменения в стилях
refactor: рефакторинг кода
test: добавить тесты
```

---

## 📞 Контакты

- 📧 **Email**: zh.vitaliy92@gmail.com
- 💬 **Telegram**: [@PyAdminRU](https://t.me/PyAdminRU)
- 🐛 **Issues**: [GitHub Issues](https://github.com/your-repo/TeleHub-v2/issues)

---

## 📜 Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для подробностей.

---

**TeleHub v2.0** - управляй Telegram-сообществами эффективно! 🚀