from django.contrib import admin

from event.models import Event, Balance, Transaction
# Register your models here.

admin.site.register(Event)
admin.site.register(Balance)
admin.site.register(Transaction)
