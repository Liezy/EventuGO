from django.contrib import admin

from event.models import Event, Balance, Transaction, Product, Sale, ProductSale
# Register your models here.

admin.site.register(Event)
admin.site.register(Balance)
admin.site.register(Transaction)
admin.site.register(Product)
admin.site.register(Sale)
admin.site.register(ProductSale)
