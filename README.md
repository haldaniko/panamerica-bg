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

Для генерации статей скопируйте `.env.sample` в `.env` и задайте `OPENROUTER_API_KEY`. Модель выбирается через `OPENROUTER_MODEL`; по умолчанию используется `openai/gpt-4.1-mini`. После изменения `.env` пересоздайте процессы командой `docker compose up -d --force-recreate backend article-scheduler`. Отдельный контейнер `article-scheduler` проверяет расписание и создаёт первую статью сразу после настройки ключа, затем — раз в 7 дней. Интервал и промпт меняются в разделе «Автоматични статии» админ-панели.

SQLite-база находится в `database/db.sqlite3` на хосте. Каталог `database/` подключается к backend и планировщику как bind mount, поэтому удаление или пересоздание контейнеров не удаляет данные. Для резервной копии остановите сервисы и скопируйте файл `database/db.sqlite3`.

## Продакшен

Скопируйте `.env.sample` в `.env`, задайте длинный случайный `DJANGO_SECRET_KEY` и настройте домен в `DJANGO_ALLOWED_HOSTS`.

```sh
docker compose -f docker-compose.prod.yml up --build -d
```

По умолчанию страница доступна на http://localhost:8020, React-админка — на http://localhost:8020/admin/, а прямой доступ к Django — на http://localhost:8021. Публикуемые порты меняются напрямую в `docker-compose.prod.yml`. Статические файлы и загруженные изображения раздаёт Nginx, Django обслуживает API через Gunicorn, а SQLite хранится вне контейнеров в `database/db.sqlite3`. Для HTTPS укажите внешний TLS reverse proxy и установите `DJANGO_SECURE_COOKIES=1`.

## Переменные окружения

| Переменная | Назначение |
| --- | --- |
| `DJANGO_SECRET_KEY` | Секрет Django для подписи сессий и защитных токенов. В production обязательно замените пример длинной случайной строкой. |
| `DJANGO_ALLOWED_HOSTS` | Разрешённые домены через запятую, без протокола и пути, например `example.com,www.example.com`. |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | Публичные HTTPS-адреса сайта через запятую, включая протокол, например `https://example.com,https://www.example.com`. |
| `DJANGO_SECURE_COOKIES` | `1` разрешает отправку cookies сессии и CSRF только по HTTPS; для локальной разработки используется `0`. |
| `OPENROUTER_API_KEY` | API-ключ OpenRouter для автоматической генерации статей. Можно оставить пустым, если генерация отключена. |
| `OPENROUTER_MODEL` | Идентификатор модели OpenRouter, которая создаёт статьи. |
| `OPENROUTER_BASE_URL` | Адрес API OpenRouter; обычно менять не требуется. |
| `OPENROUTER_SITE_URL` | Публичный адрес сайта, передаваемый OpenRouter в заголовке `HTTP-Referer`. |
| `OPENROUTER_APP_NAME` | Название приложения, передаваемое OpenRouter в заголовке `X-Title`. |
| `ARTICLE_SCHEDULER_POLL_SECONDS` | Период проверки расписания генерации в секундах; Django применяет минимум 30 секунд. |

Путь к базе и внешние порты намеренно не задаются через `.env`: SQLite подключается из `./database`, а порты меняются непосредственно в compose-файлах.

## Структура

- `frontend/src/reference/` — секции и исходные стили страницы.
- `frontend/src/main.jsx` — React, API, карусели, FAQ, форма заявки.
- `frontend/src/admin/` — React-админка на болгарском.
- `frontend/public/assets/` — локальные изображения, шрифты и видео.
- `backend/content/` — модели, API, админка и исходные данные для первого запуска.
- `database/db.sqlite3` — текущая SQLite-база, подключаемая к контейнерам с хоста.
- `scripts/localize_reference_bg.py`, `scripts/localize_data_bg.py` — воспроизводимая локализация исходного референса.
- `/api/cars/`, `/api/reviews/`, `/api/articles/`, `/api/website-settings/` — публичное редактируемое содержимое; `POST /api/leads/` — заявка.

Команда `seed_content` наполняет пустые таблицы автомобилей и отзывов. `python manage.py run_article_scheduler --once` выполняет одну проверку расписания; без `--once` команда работает постоянно. Данные, изменённые в админке, при перезапуске сохраняются.

Для повторного создания локализованных файлов из `Pan America.html` установите зависимости `pip install -r scripts/requirements.txt`, затем выполните `python scripts/localize_reference_bg.py` и `python scripts/localize_data_bg.py`. Это обновляет файлы шаблонов и исходные данные, поэтому используйте команды только при намеренном обновлении референса.
