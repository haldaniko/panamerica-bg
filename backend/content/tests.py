import io
import json
import tempfile
from unittest.mock import patch

from django.contrib.auth import get_user_model
from django.core.management import call_command
from django.test import Client, TestCase, override_settings
from django.core.files.uploadedfile import SimpleUploadedFile
from PIL import Image

from .models import Article, ArticleGenerationSettings, Car, Lead, WebsiteSettings


class ReactAdminAPITests(TestCase):
    def setUp(self):
        self.client = Client(enforce_csrf_checks=True)
        self.user = get_user_model().objects.create_superuser(username='editor', password='test-password')

    def sign_in(self):
        token = self.client.get('/api/auth/csrf/').json()['csrfToken']
        response = self.client.post('/api/auth/login/', json.dumps({'username': 'editor', 'password': 'test-password'}), content_type='application/json', HTTP_X_CSRFTOKEN=token)
        self.assertEqual(response.status_code, 200)
        return self.client.get('/api/auth/csrf/').json()['csrfToken']

    def test_staff_login_and_content_crud(self):
        self.assertEqual(self.client.get('/api/manage/cars/').status_code, 403)
        token = self.sign_in()
        self.assertTrue(self.client.get('/api/auth/me/').json()['authenticated'])
        headers = {'HTTP_X_CSRFTOKEN': token}
        payload = {'name': 'TEST CAR', 'year': 2020, 'price_eur': 1000, 'image': '1.png', 'position': 0, 'is_active': True}
        created = self.client.post('/api/manage/cars/', json.dumps(payload), content_type='application/json', **headers)
        self.assertEqual(created.status_code, 201, created.content)
        car_id = created.json()['id']
        changed = self.client.patch(f'/api/manage/cars/{car_id}/', json.dumps({'price_eur': 1200}), content_type='application/json', **headers)
        self.assertEqual(changed.status_code, 200, changed.content)
        self.assertEqual(Car.objects.get(pk=car_id).price_eur, 1200)
        deleted = self.client.delete(f'/api/manage/cars/{car_id}/', **headers)
        self.assertEqual(deleted.status_code, 204)
        self.assertFalse(Car.objects.filter(pk=car_id).exists())

    @override_settings(
        ALLOWED_HOSTS=['panamerica.bg'],
        CSRF_TRUSTED_ORIGINS=['https://panamerica.bg'],
    )
    def test_admin_login_accepts_proxied_production_https_origin(self):
        token = self.client.get(
            '/api/auth/csrf/',
            HTTP_HOST='panamerica.bg',
            HTTP_X_FORWARDED_PROTO='https',
        ).json()['csrfToken']
        response = self.client.post(
            '/api/auth/login/',
            json.dumps({'username': 'editor', 'password': 'test-password'}),
            content_type='application/json',
            HTTP_HOST='panamerica.bg',
            HTTP_ORIGIN='https://panamerica.bg',
            HTTP_REFERER='https://panamerica.bg/admin',
            HTTP_X_FORWARDED_PROTO='https',
            HTTP_X_CSRFTOKEN=token,
        )
        self.assertEqual(response.status_code, 200, response.content)

    def test_car_detail_is_public_and_all_fields_are_managed_in_admin(self):
        car = Car.objects.create(
            name='FORD MUSTANG GT', year=2021, price_eur=24500, image='1.png',
            summary='Спортен автомобил в отлично състояние.', mileage_km=42000,
            engine='5.0 V8', power_hp=450, fuel='Бензин', transmission='Автоматична',
            drivetrain='Задно', body_type='Купе', color='Черен', vin='TESTVIN123',
            condition='В движение', location='София', description='Подробно описание.',
            features='Кожен салон\nКамера за заден ход', is_active=True,
        )
        listing = self.client.get('/api/cars/').json()
        self.assertEqual(listing[0]['slug'], car.slug)
        detail = self.client.get(f'/api/cars/{car.slug}/')
        self.assertEqual(detail.status_code, 200)
        self.assertEqual(detail.json()['engine'], '5.0 V8')
        self.assertEqual(detail.json()['mileage_km'], 42000)

        token = self.sign_in()
        changed = self.client.patch(
            f'/api/manage/cars/{car.id}/',
            json.dumps({'mileage_km': 41000, 'features': 'Кожен салон\nНавигация'}),
            content_type='application/json',
            HTTP_X_CSRFTOKEN=token,
        )
        self.assertEqual(changed.status_code, 200, changed.content)
        car.refresh_from_db()
        self.assertEqual(car.mileage_km, 41000)
        self.assertEqual(car.slug, 'ford-mustang-gt')

        car.is_active = False
        car.save()
        self.assertEqual(self.client.get(f'/api/cars/{car.slug}/').status_code, 404)

    def test_seed_content_creates_cars_with_unique_slugs_and_demo_details(self):
        call_command('seed_content', verbosity=0)
        cars = list(Car.objects.order_by('position'))
        self.assertEqual(len(cars), 10)
        self.assertEqual(len({car.slug for car in cars}), 10)
        self.assertTrue(all(car.summary and car.description and car.features for car in cars))
        self.assertEqual(cars[0].slug, 'jeep-grand-cherokee')

    def test_staff_without_superuser_cannot_sign_in(self):
        get_user_model().objects.create_user(username='staff', password='test-password', is_staff=True)
        token = self.client.get('/api/auth/csrf/').json()['csrfToken']
        response = self.client.post('/api/auth/login/', json.dumps({'username': 'staff', 'password': 'test-password'}), content_type='application/json', HTTP_X_CSRFTOKEN=token)
        self.assertEqual(response.status_code, 400)
        self.assertEqual(self.client.get('/api/manage/cars/').status_code, 403)

    def test_upload_requires_staff_and_valid_image(self):
        fake = SimpleUploadedFile('fake.jpg', b'not an image', content_type='image/jpeg')
        self.assertEqual(self.client.post('/api/manage/upload/', {'file': fake}).status_code, 403)
        token = self.sign_in()
        fake = SimpleUploadedFile('fake.jpg', b'not an image', content_type='image/jpeg')
        self.assertEqual(self.client.post('/api/manage/upload/', {'file': fake}, HTTP_X_CSRFTOKEN=token).status_code, 400)
        buffer = io.BytesIO()
        Image.new('RGB', (2, 2), 'red').save(buffer, format='PNG')
        image = SimpleUploadedFile('photo.png', buffer.getvalue(), content_type='image/png')
        with tempfile.TemporaryDirectory() as directory, self.settings(MEDIA_ROOT=directory):
            response = self.client.post('/api/manage/upload/', {'file': image}, HTTP_X_CSRFTOKEN=token)
            self.assertEqual(response.status_code, 201, response.content)
            self.assertTrue(response.json()['image'].startswith('/media/uploads/'))

    def test_removed_content_endpoints_are_not_available(self):
        for path in ('managers', 'faqs', 'page-texts'):
            self.assertEqual(self.client.get(f'/api/{path}/').status_code, 404)
            self.assertEqual(self.client.get(f'/api/manage/{path}/').status_code, 404)

    def test_public_articles_only_include_published_items(self):
        published = Article.objects.create(title='Публикувана', excerpt='Кратко', content='Съдържание', is_published=True)
        hidden = Article.objects.create(title='Скрита', excerpt='Кратко', content='Съдържание', is_published=False)
        response = self.client.get('/api/articles/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual([item['title'] for item in response.json()], ['Публикувана'])
        self.assertTrue(response.json()[0]['slug'])
        self.assertEqual(self.client.get(f'/api/articles/{published.slug}/').status_code, 200)
        self.assertEqual(self.client.get(f'/api/articles/{hidden.slug}/').status_code, 404)

    def test_article_generation_settings_and_manual_generation_require_admin(self):
        self.assertEqual(self.client.get('/api/manage/article-settings/').status_code, 403)
        token = self.sign_in()
        changed = self.client.patch(
            '/api/manage/article-settings/',
            json.dumps({'prompt': 'Нов промпт', 'interval_days': 14, 'is_enabled': True}),
            content_type='application/json',
            HTTP_X_CSRFTOKEN=token,
        )
        self.assertEqual(changed.status_code, 200, changed.content)
        config = ArticleGenerationSettings.load()
        self.assertEqual(config.prompt, 'Нов промпт')
        self.assertEqual(config.interval_days, 14)
        article = Article.objects.create(title='Нова статия', excerpt='Кратко', content='Съдържание')
        with patch('content.views.generate_article', return_value=(article, '')):
            generated = self.client.post('/api/manage/article-settings/generate/', HTTP_X_CSRFTOKEN=token)
        self.assertEqual(generated.status_code, 201, generated.content)
        self.assertEqual(generated.json()['title'], 'Нова статия')

    def test_website_settings_are_public_but_only_admin_can_change_them(self):
        public = self.client.get('/api/website-settings/')
        self.assertEqual(public.status_code, 200)
        self.assertEqual(public.json()['phone'], '+48 579 774 163')
        denied = self.client.patch(
            '/api/manage/website-settings/',
            json.dumps({'phone': '+359 2 123 4567'}),
            content_type='application/json',
        )
        self.assertEqual(denied.status_code, 403)
        token = self.sign_in()
        changed = self.client.patch(
            '/api/manage/website-settings/',
            json.dumps({'phone': '+359 2 123 4567', 'email': 'office@example.bg', 'address': 'София, България'}),
            content_type='application/json',
            HTTP_X_CSRFTOKEN=token,
        )
        self.assertEqual(changed.status_code, 200, changed.content)
        config = WebsiteSettings.load()
        self.assertEqual(config.phone, '+359 2 123 4567')
        self.assertEqual(config.email, 'office@example.bg')
        self.assertEqual(config.address, 'София, България')

    def test_leads_accept_only_bulgarian_phone_numbers(self):
        accepted = self.client.post(
            '/api/leads/',
            json.dumps({'phone': '088 123 4567', 'source': 'website'}),
            content_type='application/json',
        )
        self.assertEqual(accepted.status_code, 201, accepted.content)
        lead = Lead.objects.get(pk=accepted.json()['id'])
        self.assertEqual(lead.phone, '+359881234567')
        self.assertEqual(lead.country, 'BG')
        rejected = self.client.post(
            '/api/leads/',
            json.dumps({'phone': '+48 579 774 163', 'source': 'website'}),
            content_type='application/json',
        )
        self.assertEqual(rejected.status_code, 400)
