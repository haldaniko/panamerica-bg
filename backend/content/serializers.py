import re
from datetime import timedelta
from rest_framework import serializers
from django.utils import timezone

from .models import Article, ArticleGenerationSettings, Car, Review, Lead, WebsiteSettings

class CarSerializer(serializers.ModelSerializer):
    class Meta: model = Car; fields = ['id', 'slug', 'name', 'year', 'price_eur', 'image', 'summary']

class CarDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = [
            'id', 'slug', 'name', 'year', 'price_eur', 'image', 'summary',
            'mileage_km', 'engine', 'power_hp', 'fuel', 'transmission',
            'drivetrain', 'body_type', 'color', 'vin', 'condition', 'location',
            'description', 'features',
        ]

class ReviewSerializer(serializers.ModelSerializer):
    class Meta: model = Review; fields = ['id', 'name', 'vehicle', 'text', 'image']

class ArticleSerializer(serializers.ModelSerializer):
    class Meta: model = Article; fields = ['id', 'slug', 'title', 'excerpt', 'content', 'published_at']

class LeadSerializer(serializers.ModelSerializer):
    class Meta: model = Lead; fields = ['id', 'phone', 'country', 'source', 'created_at']; read_only_fields = ['id', 'country', 'created_at']

    def validate_phone(self, value):
        digits = re.sub(r'\D', '', value)
        if value.strip().startswith('+') and not value.strip().startswith('+359'):
            raise serializers.ValidationError('Въведете валиден български телефонен номер.')
        if digits.startswith('359'):
            digits = digits[3:]
        elif digits.startswith('0'):
            digits = digits[1:]
        if len(digits) not in (8, 9):
            raise serializers.ValidationError('Въведете валиден български телефонен номер.')
        return f'+359{digits}'

class ImageNameValidation:
    def validate_image(self, value):
        if not re.fullmatch(r'(?:[^/\\]+\.(?:jpg|jpeg|png|webp)|/media/uploads/[a-f0-9-]+\.(?:jpg|png|webp))', value, re.I):
            raise serializers.ValidationError('Изберете изображение или качете файл.')
        return value

class AdminCarSerializer(ImageNameValidation, serializers.ModelSerializer):
    class Meta:
        model = Car
        fields = [
            'id', 'slug', 'name', 'year', 'price_eur', 'image', 'summary',
            'mileage_km', 'engine', 'power_hp', 'fuel', 'transmission',
            'drivetrain', 'body_type', 'color', 'vin', 'condition', 'location',
            'description', 'features', 'position', 'is_active',
        ]
        read_only_fields = ['slug']

class AdminReviewSerializer(ImageNameValidation, serializers.ModelSerializer):
    class Meta: model = Review; fields = ['id', 'name', 'vehicle', 'text', 'image', 'position', 'is_active']

class AdminArticleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Article
        fields = ['id', 'slug', 'title', 'excerpt', 'content', 'is_published', 'generated_by', 'published_at', 'updated_at']
        read_only_fields = ['slug', 'generated_by', 'published_at', 'updated_at']

class ArticleGenerationSettingsSerializer(serializers.ModelSerializer):
    next_generation_at = serializers.SerializerMethodField()

    class Meta:
        model = ArticleGenerationSettings
        fields = [
            'prompt', 'interval_days', 'is_enabled', 'last_attempt_at', 'last_generated_at',
            'last_error', 'generation_in_progress', 'next_generation_at',
        ]
        read_only_fields = ['last_attempt_at', 'last_generated_at', 'last_error', 'generation_in_progress', 'next_generation_at']

    def get_next_generation_at(self, obj):
        if not obj.is_enabled:
            return None
        if not obj.last_generated_at:
            return timezone.now()
        return obj.last_generated_at + timedelta(days=obj.interval_days)

class WebsiteSettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = WebsiteSettings
        fields = ['phone', 'email', 'address']

class AdminLeadSerializer(serializers.ModelSerializer):
    class Meta: model = Lead; fields = ['id', 'phone', 'country', 'source', 'created_at']
