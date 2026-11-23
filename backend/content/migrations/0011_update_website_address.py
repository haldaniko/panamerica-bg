from django.db import migrations, models


NEW_ADDRESS = 'Малинова долина, ул. Еньо Вълчев 2, офис 3'


def update_website_address(apps, schema_editor):
    WebsiteSettings = apps.get_model('content', 'WebsiteSettings')
    WebsiteSettings.objects.filter(pk=1).update(address=NEW_ADDRESS)


class Migration(migrations.Migration):
    dependencies = [('content', '0010_car_detail_fields')]

    operations = [
        migrations.AlterField(
            model_name='websitesettings',
            name='address',
            field=models.CharField(default=NEW_ADDRESS, max_length=300),
        ),
        migrations.RunPython(update_website_address, migrations.RunPython.noop),
    ]
