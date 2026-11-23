from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [('content', '0005_update_service_area')]

    operations = [
        migrations.DeleteModel(name='FAQ'),
        migrations.DeleteModel(name='Manager'),
        migrations.DeleteModel(name='PageText'),
    ]
