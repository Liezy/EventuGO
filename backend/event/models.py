from django.db import models
from users.models import CustomUser
from company.models import Company
from django.conf import settings
import uuid

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
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, verbose_name="UID")  # Adicione default=uuid.uuid4
    currency = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Saldo")  
    event = models.ForeignKey(Event, on_delete=models.CASCADE, verbose_name="Evento")
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Usuário")

    class Meta:
        verbose_name = "Saldo"

    def __str__(self):
        return f'{self.user} - {self.event}'

class Transaction(models.Model):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, verbose_name="UID")
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
    
class Product(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(null=True, blank=True)
    value = models.DecimalField(max_digits=10, decimal_places=2)
    qtd_stock = models.PositiveIntegerField()  # estoque
    is_active = models.BooleanField(default=True)  # ativo (sim/não)

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'product'

class Sale(models.Model):
    TYPE_CHOICES = [
        (0, 'Caixa'),
        (1, 'Online'),
    ]
    PAYMENT_STATUS_CHOICES = [
        (0, 'Não Pago'),
        (1, 'Pago'),
    ]
    
    type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    payment_status = models.CharField(max_length=10, choices=PAYMENT_STATUS_CHOICES)
    done_at = models.DateTimeField(auto_now_add=True)  
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)  

    def __str__(self):
        return f"Sale {self.id} - {self.get_type_display()}"

    class Meta:
        db_table = 'sale'

class ProductSale(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField() 

    def __str__(self):
        return f"{self.quantity}x {self.product.name} (Sale ID: {self.sale.id})"

    class Meta:
        db_table = 'product_sale'