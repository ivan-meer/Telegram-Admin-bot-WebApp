# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**TeleHub v2.0** is a modern Telegram Mini-App Community Manager built with a simplified and efficient architecture. The project has been redesigned with focus on **simplicity, speed, and user experience**.

The application consists of two main components:

1. **Frontend** (`frontend/`) - React + TypeScript Mini-App
2. **Backend** (`backend/`) - FastAPI + PostgreSQL API server

This is a complete architectural redesign from the original TGAdminWebApp, focused on creating a production-ready MVP that can be delivered in 6 weeks.

## Common Development Commands

### Running the Application
```bash
# Development mode with Docker
docker-compose -f docker/docker-compose.yml up -d

# Or run components separately
cd backend && uvicorn app.main:app --reload
cd frontend && npm run dev

# Production build
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.prod.yml up -d
```

### Development Setup
```bash
# Backend setup
cd backend
pip install -r requirements.txt
pip install -r requirements-dev.txt
uvicorn app.main:app --reload

# Frontend setup  
cd frontend
npm install
npm run dev
```

### Testing
```bash
# Backend tests
cd backend && pytest -v --cov=app

# Frontend tests
cd frontend && npm run test

# Run all CI checks
npm run lint && npm run type-check && npm run test
```

### Code Quality
```bash
# Backend formatting and linting
cd backend
black .
isort .
flake8 .
mypy .

# Frontend formatting and linting
cd frontend
npm run lint:fix
npm run type-check
```

## Architecture & Key Components

### Frontend Structure (`frontend/`)
- **React 18** with TypeScript and Vite
- **Telegram WebApp SDK** integration for native feel
- **Components**: Reusable UI components (`components/`)
- **Pages**: Main application pages (`pages/`)
- **Services**: API clients and external integrations (`services/`)
- **Hooks**: Custom React hooks for state management (`hooks/`)
- **Utils**: Helper functions and utilities (`utils/`)

### Backend Structure (`backend/`)
- **FastAPI** application with async/await
- **SQLAlchemy ORM** with PostgreSQL database
- **Models**: Database models (`models/`)
- **Services**: Business logic layer (`services/`)
- **API**: RESTful endpoints organized by domain
- **Authentication**: Telegram WebApp initData validation

### Key Features Architecture

#### Phase 1 (MVP):
1. **Unified Dashboard**: Central hub for managing communities
2. **Content Viewer**: View channel/group content through WebApp
3. **Channel Management**: Add/remove communities, manage permissions
4. **Simple Analytics**: Basic metrics and insights

#### Phase 2 (Enhancement):
1. **Smart Assistant**: AI-powered content suggestions
2. **Advanced Analytics**: Detailed performance metrics
3. **Monetization**: Telegram Stars integration

### Configuration Requirements

The application uses environment variables for configuration. Create a `.env` file:

```env
# Telegram
BOT_TOKEN=your_bot_token_here
WEBHOOK_URL=https://your-domain.com/webhook
TELEGRAM_API_ID=your_api_id
TELEGRAM_API_HASH=your_api_hash

# Database
DATABASE_URL=postgresql://user:pass@localhost/telehub
REDIS_URL=redis://localhost:6379/0

# AI
OPENAI_API_KEY=your_openai_key

# Security
SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256

# Application
ENVIRONMENT=development
LOG_LEVEL=DEBUG
```

See `.env.example` for full configuration template.

### Important File Paths
- Database: PostgreSQL (configured via DATABASE_URL)
- Logs: Structured logging via loguru
- Environment: `.env` file (root level)
- Docker: `docker/docker-compose.yml`

### Technology Stack
- **Frontend**: React 18, TypeScript, Vite, Tailwind CSS, Telegram WebApp SDK
- **Backend**: Python 3.11, FastAPI, SQLAlchemy, PostgreSQL, Redis
- **AI**: OpenAI API integration
- **DevOps**: Docker, GitHub Actions, Nginx
- **Testing**: Vitest (frontend), pytest (backend)

### Development Workflow
1. **Feature Development**: Create feature branch from `develop`
2. **Code Quality**: All code must pass linting, type checking, and tests
3. **CI/CD**: GitHub Actions runs tests and deploys to staging/production
4. **Code Review**: All changes require PR review before merging

### Performance Targets
- **Frontend**: < 2 seconds WebApp startup time
- **Backend**: < 500ms API response time (P95)
- **Uptime**: 99% availability target
- **Scalability**: Support up to 1000 concurrent users

### Security Considerations
- Telegram WebApp initData validation for authentication
- Environment variables for sensitive configuration
- Rate limiting on API endpoints
- Input validation and sanitization
- HTTPS only communication

### Legacy Code Notice
The `scr/` directory contains the original TGAdminWebApp code which is being replaced by TeleHub v2.0. During the transition:
- New features should be developed in `frontend/` and `backend/` directories
- Legacy code in `scr/` is maintained for reference but not actively developed
- Migration scripts may be needed to port data from the old system