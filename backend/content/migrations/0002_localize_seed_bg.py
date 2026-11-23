import json
from pathlib import Path

from django.db import migrations


def translate_existing_content(apps, schema_editor):
    content_dir = Path(__file__).resolve().parents[1]
    original = json.loads((content_dir / 'legacy_pl.json').read_text(encoding='utf-8'))
    translated = json.loads((content_dir / 'seed.json').read_text(encoding='utf-8'))
    for key, model_name, fields in (
        ('managers', 'Manager', ('role',)),
        ('reviews', 'Review', ('text',)),
        ('faqs', 'FAQ', ('question', 'answer')),
    ):
        model = apps.get_model('content', model_name)
        for position, (old, new) in enumerate(zip(original[key], translated[key])):
            obj = model.objects.filter(position=position).first()
            if obj is None:
                continue
            changed = []
            for field in fields:
                if getattr(obj, field) == old[field]:
                    setattr(obj, field, new[field])
                    changed.append(field)
            if changed:
                obj.save(update_fields=changed)


class Migration(migrations.Migration):
    dependencies = [('content', '0001_initial')]
    operations = [migrations.RunPython(translate_existing_content, migrations.RunPython.noop)]
