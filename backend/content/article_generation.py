import json
from datetime import timedelta
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from django.conf import settings
from django.db import transaction
from django.utils import timezone

from .models import Article, ArticleGenerationSettings


class ArticleGenerationError(RuntimeError):
    pass


def _claim_generation(force=False):
    now = timezone.now()
    with transaction.atomic():
        config = ArticleGenerationSettings.objects.select_for_update().filter(pk=1).first()
        if config is None:
            config = ArticleGenerationSettings.objects.create(pk=1)
        stale = config.generation_started_at and config.generation_started_at < now - timedelta(minutes=30)
        if config.generation_in_progress and not stale:
            return None, 'Вече се генерира статия.'
        if not force:
            if not config.is_enabled:
                return None, 'Автоматичното генериране е изключено.'
            key_was_just_configured = (
                config.last_error == 'OPENROUTER_API_KEY не е настроен.'
                and bool(settings.OPENROUTER_API_KEY)
            )
            if config.last_attempt_at and config.last_attempt_at > now - timedelta(hours=1) and not key_was_just_configured:
                return None, 'Следващият опит още не е настъпил.'
            if config.last_generated_at and config.last_generated_at + timedelta(days=config.interval_days) > now:
                return None, 'Следващата статия още не е насрочена.'
        config.generation_in_progress = True
        config.generation_started_at = now
        config.last_attempt_at = now
        config.last_error = ''
        config.save(update_fields=['generation_in_progress', 'generation_started_at', 'last_attempt_at', 'last_error'])
        return config, ''


def _openrouter_request(prompt):
    if not settings.OPENROUTER_API_KEY:
        raise ArticleGenerationError('OPENROUTER_API_KEY не е настроен.')
    recent_titles = list(Article.objects.values_list('title', flat=True)[:12])
    user_prompt = prompt.strip()
    if recent_titles:
        user_prompt += '\n\nПоследни публикувани заглавия, които не трябва да повтаряш:\n- ' + '\n- '.join(recent_titles)
    payload = {
        'model': settings.OPENROUTER_MODEL,
        'messages': [
            {
                'role': 'system',
                'content': 'Ти си автомобилен редактор. Върни само валиден JSON на български език според зададената схема. Съдържанието да е 700–1100 думи, с кратки абзаци и подзаглавия на отделни редове, без Markdown заглавие и без HTML.',
            },
            {'role': 'user', 'content': user_prompt},
        ],
        'temperature': 0.7,
        'max_completion_tokens': 2200,
        'response_format': {
            'type': 'json_schema',
            'json_schema': {
                'name': 'car_article',
                'strict': True,
                'schema': {
                    'type': 'object',
                    'properties': {
                        'title': {'type': 'string', 'maxLength': 160},
                        'excerpt': {'type': 'string', 'maxLength': 320},
                        'content': {'type': 'string'},
                    },
                    'required': ['title', 'excerpt', 'content'],
                    'additionalProperties': False,
                },
            },
        },
        'provider': {'require_parameters': True},
    }
    headers = {
        'Authorization': f'Bearer {settings.OPENROUTER_API_KEY}',
        'Content-Type': 'application/json',
        'X-Title': settings.OPENROUTER_APP_NAME,
    }
    if settings.OPENROUTER_SITE_URL:
        headers['HTTP-Referer'] = settings.OPENROUTER_SITE_URL
    request = Request(
        f"{settings.OPENROUTER_BASE_URL.rstrip('/')}/chat/completions",
        data=json.dumps(payload).encode('utf-8'),
        headers=headers,
        method='POST',
    )
    try:
        with urlopen(request, timeout=90) as response:
            result = json.loads(response.read().decode('utf-8'))
    except HTTPError as exc:
        detail = exc.read().decode('utf-8', errors='replace')[:1000]
        raise ArticleGenerationError(f'OpenRouter върна HTTP {exc.code}: {detail}') from exc
    except (URLError, TimeoutError, json.JSONDecodeError) as exc:
        raise ArticleGenerationError(f'Грешка при връзката с OpenRouter: {exc}') from exc
    try:
        content = result['choices'][0]['message']['content']
        if isinstance(content, list):
            content = ''.join(part.get('text', '') for part in content if isinstance(part, dict))
        article = json.loads(content)
        title = article['title'].strip()
        excerpt = article['excerpt'].strip()
        body = article['content'].strip()
    except (KeyError, IndexError, TypeError, json.JSONDecodeError) as exc:
        raise ArticleGenerationError('OpenRouter върна невалиден формат на статията.') from exc
    if not title or not excerpt or len(body) < 500:
        raise ArticleGenerationError('Генерираната статия е празна или твърде кратка.')
    return title[:160], excerpt[:320], body


def generate_article(force=False):
    config, reason = _claim_generation(force=force)
    if config is None:
        return None, reason
    try:
        title, excerpt, content = _openrouter_request(config.prompt)
        article = Article.objects.create(
            title=title,
            excerpt=excerpt,
            content=content,
            generated_by=settings.OPENROUTER_MODEL,
        )
        now = timezone.now()
        ArticleGenerationSettings.objects.filter(pk=1).update(
            last_generated_at=now,
            last_error='',
            generation_in_progress=False,
            generation_started_at=None,
        )
        return article, ''
    except Exception as exc:
        message = str(exc)[:2000]
        ArticleGenerationSettings.objects.filter(pk=1).update(
            last_error=message,
            generation_in_progress=False,
            generation_started_at=None,
        )
        if isinstance(exc, ArticleGenerationError):
            raise
        raise ArticleGenerationError(message) from exc
