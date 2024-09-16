from django.contrib import admin
from credits.models import HistoricoTransacao, Saldo, Transacao

# Register your models here.
admin.site.register(Saldo)
admin.site.register(Transacao)
admin.site.register(HistoricoTransacao)
