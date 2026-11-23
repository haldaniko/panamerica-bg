from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [('content', '0007_article_and_generation_settings')]

    operations = [
        migrations.CreateModel(
            name='WebsiteSettings',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('phone', models.CharField(default='+48 579 774 163', max_length=40)),
                ('email', models.EmailField(default='hello@panamericaauto.pl', max_length=254)),
                ('address', models.CharField(default='Вроцлав, 54-203, ул. Легницка 59, офис 22B, Полша', max_length=300)),
            ],
        ),
    ]
