from django.db import migrations, models


TRANSLITERATION = str.maketrans({
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ж': 'zh',
    'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n',
    'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f',
    'х': 'h', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'sht', 'ъ': 'a',
    'ь': 'y', 'ю': 'yu', 'я': 'ya',
})


def populate_slugs(apps, schema_editor):
    from django.utils.text import slugify

    Article = apps.get_model('content', 'Article')
    used = set()
    for article in Article.objects.order_by('id'):
        base = slugify(article.title.lower().translate(TRANSLITERATION))[:180] or f'statia-{article.id}'
        candidate = base
        index = 2
        while candidate in used:
            candidate = f'{base[:180]}-{index}'
            index += 1
        article.slug = candidate
        article.save(update_fields=['slug'])
        used.add(candidate)


class Migration(migrations.Migration):
    dependencies = [('content', '0008_website_settings')]

    operations = [
        migrations.AddField(
            model_name='article',
            name='slug',
            field=models.CharField(blank=True, default='', max_length=190),
            preserve_default=False,
        ),
        migrations.RunPython(populate_slugs, migrations.RunPython.noop),
        migrations.AlterField(
            model_name='article',
            name='slug',
            field=models.SlugField(blank=True, max_length=190, unique=True),
        ),
    ]
