from django.db import migrations


OLD = 'Работим на територията на цяла Полша'
NEW = 'Работим на територията на цяла България'


def update_service_area(apps, schema_editor):
    PageText = apps.get_model('content', 'PageText')
    item = PageText.objects.filter(key='header:38d3a72c71c4').first()
    if item is None:
        return
    fields = []
    if item.source_text == OLD:
        item.source_text = NEW
        fields.append('source_text')
    if item.value == OLD:
        item.value = NEW
        fields.append('value')
    if fields:
        item.save(update_fields=fields)


class Migration(migrations.Migration):
    dependencies = [('content', '0004_pagetext')]
    operations = [migrations.RunPython(update_service_area, migrations.RunPython.noop)]
