from django.db import migrations, models
from django.utils.text import slugify


def populate_car_slugs(apps, schema_editor):
    Car = apps.get_model('content', 'Car')
    used = set()
    for car in Car.objects.order_by('id'):
        base = slugify(car.name)[:180] or 'avtomobil'
        candidate = base
        index = 2
        while candidate in used:
            candidate = f'{base[:180]}-{index}'
            index += 1
        car.slug = candidate
        car.save(update_fields=['slug'])
        used.add(candidate)


class Migration(migrations.Migration):
    dependencies = [('content', '0009_article_slug')]

    operations = [
        migrations.AddField(model_name='car', name='slug', field=models.CharField(blank=True, max_length=190, null=True)),
        migrations.AddField(model_name='car', name='summary', field=models.CharField(blank=True, max_length=320)),
        migrations.AddField(model_name='car', name='mileage_km', field=models.PositiveIntegerField(blank=True, null=True)),
        migrations.AddField(model_name='car', name='engine', field=models.CharField(blank=True, max_length=120)),
        migrations.AddField(model_name='car', name='power_hp', field=models.PositiveSmallIntegerField(blank=True, null=True)),
        migrations.AddField(model_name='car', name='fuel', field=models.CharField(blank=True, max_length=80)),
        migrations.AddField(model_name='car', name='transmission', field=models.CharField(blank=True, max_length=120)),
        migrations.AddField(model_name='car', name='drivetrain', field=models.CharField(blank=True, max_length=80)),
        migrations.AddField(model_name='car', name='body_type', field=models.CharField(blank=True, max_length=80)),
        migrations.AddField(model_name='car', name='color', field=models.CharField(blank=True, max_length=80)),
        migrations.AddField(model_name='car', name='vin', field=models.CharField(blank=True, max_length=64)),
        migrations.AddField(model_name='car', name='condition', field=models.CharField(blank=True, max_length=120)),
        migrations.AddField(model_name='car', name='location', field=models.CharField(blank=True, max_length=160)),
        migrations.AddField(model_name='car', name='description', field=models.TextField(blank=True)),
        migrations.AddField(model_name='car', name='features', field=models.TextField(blank=True, help_text='Една характеристика на ред.')),
        migrations.RunPython(populate_car_slugs, migrations.RunPython.noop),
        migrations.AlterField(model_name='car', name='slug', field=models.SlugField(blank=True, max_length=190, unique=True)),
    ]
