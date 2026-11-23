from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from content import views

urlpatterns = [
    path('django-admin/', admin.site.urls),
    path('api/', include('content.urls')),
    path('health/', views.health),
] + (static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT) if settings.DEBUG else [])
