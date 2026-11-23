from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils.text import slugify


DEFAULT_ARTICLE_PROMPT = """Напиши полезна и оригинална статия на български език за автомобили. Темата може да е избор и покупка на автомобил, внос от САЩ, поддръжка, безопасност, технологии или пазарни тенденции. Текстът трябва да е практичен, достъпен и подходящ за клиентите на Pan America. Не измисляй конкретни цени, закони или статистики. Не повтаряй темите на последните статии."""

BG_TRANSLITERATION = str.maketrans({
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ж': 'zh',
    'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n',
    'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f',
    'х': 'h', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'sht', 'ъ': 'a',
    'ь': 'y', 'ю': 'yu', 'я': 'ya',
})


def article_slug(value):
    return slugify(value.lower().translate(BG_TRANSLITERATION))[:180] or 'statia'

class OrderedContent(models.Model):
    position = models.PositiveIntegerField(default=0)
    is_active = models.BooleanField(default=True)

    class Meta:
        abstract = True
        ordering = ['position', 'id']

class Car(OrderedContent):
    name = models.CharField(max_length=160)
    slug = models.SlugField(max_length=190, unique=True, blank=True)
    year = models.PositiveSmallIntegerField()
    price_eur = models.PositiveIntegerField()
    image = models.CharField(max_length=200)
    summary = models.CharField(max_length=320, blank=True)
    mileage_km = models.PositiveIntegerField(null=True, blank=True)
    engine = models.CharField(max_length=120, blank=True)
    power_hp = models.PositiveSmallIntegerField(null=True, blank=True)
    fuel = models.CharField(max_length=80, blank=True)
    transmission = models.CharField(max_length=120, blank=True)
    drivetrain = models.CharField(max_length=80, blank=True)
    body_type = models.CharField(max_length=80, blank=True)
    color = models.CharField(max_length=80, blank=True)
    vin = models.CharField(max_length=64, blank=True)
    condition = models.CharField(max_length=120, blank=True)
    location = models.CharField(max_length=160, blank=True)
    description = models.TextField(blank=True)
    features = models.TextField(blank=True, help_text='Една характеристика на ред.')

    def save(self, *args, **kwargs):
        if not self.slug:
            base = slugify(self.name)[:180] or 'avtomobil'
            candidate = base
            index = 2
            while Car.objects.exclude(pk=self.pk).filter(slug=candidate).exists():
                candidate = f'{base[:180]}-{index}'
                index += 1
            self.slug = candidate
        super().save(*args, **kwargs)

    def __str__(self): return self.name

class Review(OrderedContent):
    name = models.CharField(max_length=160)
    vehicle = models.CharField(max_length=200)
    text = models.TextField()
    image = models.CharField(max_length=200)

    def __str__(self): return self.name

class Lead(models.Model):
    phone = models.CharField(max_length=30)
    country = models.CharField(max_length=2, default='BG')
    source = models.CharField(max_length=80, default='website')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self): return f'{self.phone} ({self.created_at:%Y-%m-%d})'


class Article(models.Model):
    title = models.CharField(max_length=160)
    slug = models.SlugField(max_length=190, unique=True, blank=True)
    excerpt = models.CharField(max_length=320)
    content = models.TextField()
    is_published = models.BooleanField(default=True)
    generated_by = models.CharField(max_length=120, blank=True)
    published_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-published_at', '-id']

    def save(self, *args, **kwargs):
        if not self.slug:
            base = article_slug(self.title)
            candidate = base
            index = 2
            while Article.objects.exclude(pk=self.pk).filter(slug=candidate).exists():
                candidate = f'{base[:180]}-{index}'
                index += 1
            self.slug = candidate
        super().save(*args, **kwargs)

    def __str__(self): return self.title


class ArticleGenerationSettings(models.Model):
    prompt = models.TextField(default=DEFAULT_ARTICLE_PROMPT)
    interval_days = models.PositiveSmallIntegerField(
        default=7,
        validators=[MinValueValidator(1), MaxValueValidator(365)],
    )
    is_enabled = models.BooleanField(default=True)
    last_attempt_at = models.DateTimeField(null=True, blank=True)
    last_generated_at = models.DateTimeField(null=True, blank=True)
    last_error = models.TextField(blank=True)
    generation_in_progress = models.BooleanField(default=False)
    generation_started_at = models.DateTimeField(null=True, blank=True)

    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)

    @classmethod
    def load(cls):
        instance, _ = cls.objects.get_or_create(pk=1)
        return instance

    def __str__(self): return 'Настройки за автоматични статии'


class WebsiteSettings(models.Model):
    phone = models.CharField(max_length=40, default='+48 579 774 163')
    email = models.EmailField(default='hello@panamericaauto.pl')
    address = models.CharField(max_length=300, default='Малинова долина, ул. Еньо Вълчев 2, офис 3')

    def save(self, *args, **kwargs):
        self.pk = 1
        super().save(*args, **kwargs)

    @classmethod
    def load(cls):
        instance, _ = cls.objects.get_or_create(pk=1)
        return instance

    def __str__(self): return 'Настройки на сайта'
