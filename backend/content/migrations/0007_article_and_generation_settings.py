import django.core.validators
from django.db import migrations, models

import content.models


class Migration(migrations.Migration):
    dependencies = [('content', '0006_remove_dynamic_faqs_managers_and_page_texts')]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=160)),
                ('excerpt', models.CharField(max_length=320)),
                ('content', models.TextField()),
                ('is_published', models.BooleanField(default=True)),
                ('generated_by', models.CharField(blank=True, max_length=120)),
                ('published_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={'ordering': ['-published_at', '-id']},
        ),
        migrations.CreateModel(
            name='ArticleGenerationSettings',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('prompt', models.TextField(default=content.models.DEFAULT_ARTICLE_PROMPT)),
                ('interval_days', models.PositiveSmallIntegerField(default=7, validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(365)])),
                ('is_enabled', models.BooleanField(default=True)),
                ('last_attempt_at', models.DateTimeField(blank=True, null=True)),
                ('last_generated_at', models.DateTimeField(blank=True, null=True)),
                ('last_error', models.TextField(blank=True)),
                ('generation_in_progress', models.BooleanField(default=False)),
                ('generation_started_at', models.DateTimeField(blank=True, null=True)),
            ],
        ),
    ]
