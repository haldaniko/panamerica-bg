from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register('cars', views.AdminCars, basename='manage-cars')
router.register('reviews', views.AdminReviews, basename='manage-reviews')
router.register('articles', views.AdminArticles, basename='manage-articles')
router.register('leads', views.AdminLeads, basename='manage-leads')

urlpatterns = [
    path('cars/', views.Cars.as_view()),
    path('cars/<slug:slug>/', views.CarDetail.as_view()),
    path('reviews/', views.Reviews.as_view()),
    path('articles/', views.Articles.as_view()),
    path('articles/<slug:slug>/', views.ArticleDetail.as_view()),
    path('website-settings/', views.website_settings),
    path('leads/', views.Leads.as_view()),
    path('auth/csrf/', views.csrf_token),
    path('auth/me/', views.current_user),
    path('auth/login/', views.login_user),
    path('auth/logout/', views.logout_user),
    path('manage/upload/', views.upload_image),
    path('manage/article-settings/', views.article_generation_settings),
    path('manage/website-settings/', views.manage_website_settings),
    path('manage/article-settings/generate/', views.generate_article_now),
    path('manage/', include(router.urls)),
]
