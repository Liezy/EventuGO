from django.db import models
from django.conf import settings
from django.utils import timezone
from evento.models import Evento

class Saldo(models.Model):
    usuario = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='saldo')
    saldo_atual = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)

    def __str__(self):
        return f'{self.usuario.username} - Saldo: {self.saldo_atual}'

class Transacao(models.Model):
    TIPO_TRANSACAO = (
        ('RECARGA', 'Recarga'),
        ('PAGAMENTO', 'Pagamento'),
    )

    usuario = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='transacoes')
    evento = models.ForeignKey(Evento, on_delete=models.CASCADE, related_name='transacoes')
    tipo = models.CharField(max_length=20, choices=TIPO_TRANSACAO)
    valor = models.DecimalField(max_digits=10, decimal_places=2)
    data_hora = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f'{self.usuario.username} - {self.tipo} - {self.valor}'

class HistoricoTransacao(models.Model):
    transacao = models.ForeignKey(Transacao, on_delete=models.CASCADE, related_name='historico')
    data_hora = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f'Transação ID: {self.transacao.id} - {self.data_hora}'
