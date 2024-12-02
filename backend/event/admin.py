from django.contrib import admin

from event.models import Event, Balance, Transaction, Product, Sale, SaleProduct
# Register your models here.

# admin.site.register(Event)
admin.site.register(Balance)
admin.site.register(Transaction)
# admin.site.register(Product)
admin.site.register(Sale)
admin.site.register(SaleProduct)
from django.contrib import admin
from .models import Event, Product

@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ('name', 'type', 'start_date', 'end_date', 'company')

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'value', 'qtd_stock', 'is_active')
    filter_horizontal = ('events',) 

