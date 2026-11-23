import json
import uuid

from django.conf import settings
from django.contrib.auth import authenticate, login, logout
from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.http import JsonResponse
from django.middleware.csrf import get_token
from django.views.decorators.csrf import csrf_protect, ensure_csrf_cookie
from django.views.decorators.http import require_GET, require_POST
from PIL import Image, UnidentifiedImageError
from rest_framework import generics, status, viewsets
from rest_framework.authentication import SessionAuthentication
from rest_framework.decorators import api_view, authentication_classes, parser_classes, permission_classes
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import BasePermission
from rest_framework.response import Response
from rest_framework.throttling import AnonRateThrottle

from .article_generation import ArticleGenerationError, generate_article
from .models import Article, ArticleGenerationSettings, Car, Review, Lead, WebsiteSettings
from .serializers import (
    ArticleSerializer, CarSerializer, CarDetailSerializer, ReviewSerializer, LeadSerializer,
    AdminArticleSerializer, AdminCarSerializer, AdminReviewSerializer, AdminLeadSerializer,
    ArticleGenerationSettingsSerializer,
    WebsiteSettingsSerializer,
)


class IsSiteAdministrator(BasePermission):
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.is_superuser)


def health(request):
    return JsonResponse({'status': 'ok'})


class Cars(generics.ListAPIView):
    queryset = Car.objects.filter(is_active=True)
    serializer_class = CarSerializer


class CarDetail(generics.RetrieveAPIView):
    queryset = Car.objects.filter(is_active=True)
    serializer_class = CarDetailSerializer
    lookup_field = 'slug'


class Reviews(generics.ListAPIView):
    queryset = Review.objects.filter(is_active=True)
    serializer_class = ReviewSerializer


class Articles(generics.ListAPIView):
    queryset = Article.objects.filter(is_published=True)
    serializer_class = ArticleSerializer
    pagination_class = None


class ArticleDetail(generics.RetrieveAPIView):
    queryset = Article.objects.filter(is_published=True)
    serializer_class = ArticleSerializer
    lookup_field = 'slug'


@api_view(['GET'])
def website_settings(request):
    return Response(WebsiteSettingsSerializer(WebsiteSettings.load()).data)


class LeadThrottle(AnonRateThrottle):
    scope = 'lead'


class Leads(generics.CreateAPIView):
    serializer_class = LeadSerializer
    throttle_classes = [LeadThrottle]


@require_GET
@ensure_csrf_cookie
def csrf_token(request):
    return JsonResponse({'csrfToken': get_token(request)})


@require_GET
def current_user(request):
    user = request.user
    return JsonResponse({'authenticated': bool(user.is_authenticated and user.is_superuser), 'username': user.get_username() if user.is_authenticated and user.is_superuser else ''})


@require_POST
@csrf_protect
def login_user(request):
    try:
        payload = json.loads(request.body)
    except (ValueError, UnicodeDecodeError):
        return JsonResponse({'detail': 'Невалидна заявка.'}, status=400)
    user = authenticate(request, username=payload.get('username', ''), password=payload.get('password', ''))
    if user is None or not user.is_superuser:
        return JsonResponse({'detail': 'Невалидни данни за вход или липса на администраторски достъп.'}, status=400)
    login(request, user)
    return JsonResponse({'authenticated': True, 'username': user.get_username()})


@require_POST
@csrf_protect
def logout_user(request):
    logout(request)
    return JsonResponse({'authenticated': False})


class StaffViewSet(viewsets.ModelViewSet):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsSiteAdministrator]
    pagination_class = None


class AdminCars(StaffViewSet):
    queryset = Car.objects.all()
    serializer_class = AdminCarSerializer


class AdminReviews(StaffViewSet):
    queryset = Review.objects.all()
    serializer_class = AdminReviewSerializer


class AdminArticles(StaffViewSet):
    queryset = Article.objects.all()
    serializer_class = AdminArticleSerializer


class AdminLeads(viewsets.ReadOnlyModelViewSet):
    authentication_classes = [SessionAuthentication]
    permission_classes = [IsSiteAdministrator]
    pagination_class = None
    queryset = Lead.objects.order_by('-created_at')
    serializer_class = AdminLeadSerializer


@api_view(['GET', 'PATCH'])
@authentication_classes([SessionAuthentication])
@permission_classes([IsSiteAdministrator])
def article_generation_settings(request):
    config = ArticleGenerationSettings.load()
    if request.method == 'PATCH':
        serializer = ArticleGenerationSettingsSerializer(config, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
    return Response(ArticleGenerationSettingsSerializer(config).data)


@api_view(['GET', 'PATCH'])
@authentication_classes([SessionAuthentication])
@permission_classes([IsSiteAdministrator])
def manage_website_settings(request):
    config = WebsiteSettings.load()
    if request.method == 'PATCH':
        serializer = WebsiteSettingsSerializer(config, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
    return Response(WebsiteSettingsSerializer(config).data)


@api_view(['POST'])
@authentication_classes([SessionAuthentication])
@permission_classes([IsSiteAdministrator])
def generate_article_now(request):
    try:
        article, reason = generate_article(force=True)
    except ArticleGenerationError as exc:
        return Response({'detail': str(exc)}, status=status.HTTP_502_BAD_GATEWAY)
    if article is None:
        return Response({'detail': reason}, status=status.HTTP_409_CONFLICT)
    return Response(AdminArticleSerializer(article).data, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@authentication_classes([SessionAuthentication])
@permission_classes([IsSiteAdministrator])
@parser_classes([MultiPartParser])
def upload_image(request):
    uploaded = request.FILES.get('file')
    if not uploaded or uploaded.size > 5 * 1024 * 1024:
        return Response({'detail': 'Изберете изображение до 5 MB.'}, status=status.HTTP_400_BAD_REQUEST)
    try:
        image = Image.open(uploaded)
        image.verify()
        fmt = image.format
    except (UnidentifiedImageError, OSError, ValueError):
        return Response({'detail': 'Невалиден файл с изображение.'}, status=status.HTTP_400_BAD_REQUEST)
    extension = {'JPEG': 'jpg', 'PNG': 'png', 'WEBP': 'webp'}.get(fmt)
    if not extension:
        return Response({'detail': 'Поддържат се JPG, PNG и WebP.'}, status=status.HTTP_400_BAD_REQUEST)
    uploaded.seek(0)
    filename = default_storage.save(f'uploads/{uuid.uuid4().hex}.{extension}', ContentFile(uploaded.read()))
    return Response({'image': f'{settings.MEDIA_URL}{filename}'}, status=status.HTTP_201_CREATED)
