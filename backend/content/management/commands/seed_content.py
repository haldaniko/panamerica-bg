import json
from pathlib import Path
from django.core.management.base import BaseCommand
from content.models import Car, Review

class Command(BaseCommand):
    help = 'Load the content from the saved reference page (only into empty tables).'

    def handle(self, *args, **options):
        data = json.loads((Path(__file__).resolve().parents[2] / 'seed.json').read_text(encoding='utf-8'))
        for key, model in [('cars', Car), ('reviews', Review)]:
            if model.objects.exists():
                self.stdout.write(f'{key}: already populated')
                continue
            model.objects.bulk_create(model(position=i, **item) for i, item in enumerate(data[key]))
            self.stdout.write(f'{key}: {len(data[key])} loaded')
