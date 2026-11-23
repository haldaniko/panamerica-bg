import time

from django.conf import settings
from django.core.management.base import BaseCommand

from content.article_generation import ArticleGenerationError, generate_article


class Command(BaseCommand):
    help = 'Generate due articles with OpenRouter and keep checking the configured schedule.'

    def add_arguments(self, parser):
        parser.add_argument('--once', action='store_true', help='Check once and exit.')

    def handle(self, *args, **options):
        while True:
            try:
                article, reason = generate_article()
                if article:
                    self.stdout.write(self.style.SUCCESS(f'Generated article: {article.title}'))
                elif options['once']:
                    self.stdout.write(reason)
            except ArticleGenerationError as exc:
                self.stderr.write(self.style.ERROR(str(exc)))
            if options['once']:
                return
            time.sleep(settings.ARTICLE_SCHEDULER_POLL_SECONDS)
