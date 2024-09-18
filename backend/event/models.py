from django.db import models
from users.models import CustomUser
from company.models import Company
from django.conf import settings

class Event(models.Model):
    name = models.CharField(max_length=255, verbose_name="Nome")
    description = models.TextField(verbose_name="Descrição")
    type = models.CharField(max_length=50, verbose_name="Tipo")
    start_date = models.DateTimeField(verbose_name="Data de Início")
    end_date = models.DateTimeField(verbose_name="Data de Término")
    company = models.ForeignKey(Company, on_delete=models.CASCADE, verbose_name="Empresa")

    class Meta:
        verbose_name = "Evento"
        verbose_name_plural = "Eventos"

    def __str__(self):
        return self.name

class Balance(models.Model):  
    uid = models.UUIDField(primary_key=True, editable=False, verbose_name="UID")
    currency = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Saldo")  
    event = models.ForeignKey(Event, on_delete=models.CASCADE, verbose_name="Evento")
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Usuário")

    class Meta:
        verbose_name = "Saldo"

    def __str__(self):
        return f'{self.user} - {self.event}'

class Transaction(models.Model):
    uid = models.UUIDField(primary_key=True, editable=False, verbose_name="UID")
    value = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Valor")
    type = models.CharField(max_length=50, verbose_name="Tipo")
    hash = models.CharField(max_length=255, verbose_name="Hash")
    done_at = models.DateTimeField(auto_now_add=True, verbose_name="Data/Hora de conclusão")
    currency = models.ForeignKey(Balance, on_delete=models.CASCADE, verbose_name="Valor")

    class Meta:
        verbose_name = "Transação"
        verbose_name_plural = "Transações"

    def __str__(self):
        return f'{self.type} - {self.value}'
