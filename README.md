# Pan America — Django REST Framework + React

Главная страница перенесена из локального референса `Pan America.html` с сохранением разметки, стилей, изображений, шрифтов и видео. Интерфейс и содержимое переведены на болгарский. Автомобили, отзывы и статьи редактируются в React-админке и загружаются через API; FAQ и тексты статических секций хранятся во frontend-коде. Заявки из формы сохраняются в базе. Новые статьи автоматически генерируются через OpenRouter.

## Разработка

```sh
docker compose up --build
```

Страница: http://localhost:5173 · политика за поверителност: http://localhost:5173/privacy-policy · React-админка: http://localhost:5173/admin/ · API: http://localhost:8000/api/ · резервная Django-админка: http://localhost:8000/django-admin/

Для создания администратора:

```sh
docker compose exec backend python manage.py createsuperuser
```

Исходный код монтируется в контейнеры, поэтому Vite и Django обновляются при изменениях.

В React-админку войдите учётной записью, созданной через `createsuperuser`. В ней можно добавлять, редактировать, скрывать и удалять автомобили, отзывы и статьи, настраивать телефон, email и адрес сайта, управлять промптом и периодичностью генерации, запускать генерацию вручную, загружать изображения и просматривать заявки. Доступ к изменению данных есть только у суперпользователей Django. Запросы защищены сессией и CSRF.

Для генерации статей скопируйте `.env.example` в `.env` и задайте `OPENROUTER_API_KEY`. Модель выбирается через `OPENROUTER_MODEL`; по умолчанию используется `openai/gpt-4.1-mini`. После изменения `.env` пересоздайте процессы командой `docker compose up -d --force-recreate backend article-scheduler`. Отдельный контейнер `article-scheduler` проверяет расписание и создаёт первую статью сразу после настройки ключа, затем — раз в 7 дней. Интервал и промпт меняются в разделе «Автоматични статии» админ-панели.

## Продакшен

Скопируйте `.env.example` в `.env`, задайте длинные случайные `POSTGRES_PASSWORD` и `DJANGO_SECRET_KEY`, настройте домен в `DJANGO_ALLOWED_HOSTS` и `CSRF_TRUSTED_ORIGINS`.

```sh
docker compose -f docker-compose.prod.yml up --build -d
```

Страница: http://localhost:8080 (или порт `HTTP_PORT`), React-админка: http://localhost:8080/admin/. Статические файлы и загруженные изображения раздаёт Nginx. Django обслуживает API через Gunicorn; PostgreSQL и изображения хранятся в отдельных томах. Для HTTPS укажите внешний TLS reverse proxy и установите `DJANGO_SECURE_COOKIES=1`.

## Структура

- `frontend/src/reference/` — секции и исходные стили страницы.
- `frontend/src/main.jsx` — React, API, карусели, FAQ, форма заявки.
- `frontend/src/admin/` — React-админка на болгарском.
- `frontend/public/assets/` — локальные изображения, шрифты и видео.
- `backend/content/` — модели, API, админка и исходные данные для первого запуска.
- `scripts/localize_reference_bg.py`, `scripts/localize_data_bg.py` — воспроизводимая локализация исходного референса.
- `/api/cars/`, `/api/reviews/`, `/api/articles/`, `/api/website-settings/` — публичное редактируемое содержимое; `POST /api/leads/` — заявка.

Команда `seed_content` наполняет пустые таблицы автомобилей и отзывов. `python manage.py run_article_scheduler --once` выполняет одну проверку расписания; без `--once` команда работает постоянно. Данные, изменённые в админке, при перезапуске сохраняются.

Для повторного создания локализованных файлов из `Pan America.html` установите зависимости `pip install -r scripts/requirements.txt`, затем выполните `python scripts/localize_reference_bg.py` и `python scripts/localize_data_bg.py`. Это обновляет файлы шаблонов и исходные данные, поэтому используйте команды только при намеренном обновлении референса.
