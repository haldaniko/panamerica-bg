from django.contrib import admin
from .models import Article, ArticleGenerationSettings, Car, Review, Lead, WebsiteSettings

admin.site.site_header = 'Pan America — администрация'
admin.site.site_title = 'Pan America — администрация'
admin.site.index_title = 'Управление на съдържанието'

@admin.register(Car)
class CarAdmin(admin.ModelAdmin):
    list_display = ('name', 'year', 'price_eur', 'is_active', 'position')
    list_filter = ('is_active', 'year', 'fuel', 'transmission')
    search_fields = ('name', 'vin', 'location')
    readonly_fields = ('slug',)

for model in (Review, Article, ArticleGenerationSettings, WebsiteSettings):
    admin.site.register(model)

@admin.register(Lead)
class LeadAdmin(admin.ModelAdmin):
    list_display = ('phone', 'country', 'source', 'created_at')
    list_filter = ('country', 'source', 'created_at')
    search_fields = ('phone',)
