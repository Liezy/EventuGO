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
    image = models.ImageField(upload_to='products/', null=True, blank=True, verbose_name="Imagem")

    class Meta:
        verbose_name = "Evento"
        verbose_name_plural = "Eventos"

    def __str__(self):
        return self.name

class Balance(models.Model):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, verbose_name="UID")
    currency = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Saldo")
    event = models.ForeignKey(Event, on_delete=models.CASCADE, verbose_name="Evento")
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Usuário")

    class Meta:
        verbose_name = "Saldo"

    def __str__(self):
        return f'{self.user} - {self.event}'

    def recharge(self, amount):
        """
        Método para recarregar o saldo.
        """
        if amount <= 0:
            raise ValueError("O valor da recarga deve ser positivo.")

        self.currency += amount
        self.save()

        # Cria a transação de recarga
        transaction = Transaction.objects.create(
            value=amount,
            type=0,  # 0 representa 'Recarga'
            hash=uuid.uuid4().hex,
            currency=self,
        )
        return transaction


class Transaction(models.Model):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, verbose_name="UID")
    value = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Valor")

    TYPE_CHOICES = [
        (0, 'Recarga'),
        (1, 'Compra'),
    ]

    # type = models.CharField(max_length=50, choices=TYPE_CHOICES, verbose_name="Tipo")
    type = models.PositiveIntegerField(choices=TYPE_CHOICES, default=0)
    hash = models.CharField(max_length=255, verbose_name="Hash")
    done_at = models.DateTimeField(auto_now_add=True, verbose_name="Data/Hora de conclusão")
    currency = models.ForeignKey(Balance, on_delete=models.CASCADE, verbose_name="Valor")

    class Meta:
        verbose_name = "Transação"
        verbose_name_plural = "Transações"

    def __str__(self):
        return f'{self.type} - {self.value}'
    
class Product(models.Model):
    name = models.CharField(max_length=255, verbose_name="Nome")
    description = models.TextField(null=True, blank=True, verbose_name="Descrição")
    value = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Valor")
    qtd_stock = models.PositiveIntegerField(verbose_name="Quantidade em Estoque")  # Estoque
    is_active = models.BooleanField(default=True, verbose_name="Ativo")  # Ativo ou inativo
    events = models.ManyToManyField('Event', blank=True, related_name="products", verbose_name="Eventos")
    image = models.ImageField(upload_to='products/', null=True, blank=True, verbose_name="Imagem")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Produto"
        verbose_name_plural = "Produtos"


class Sale(models.Model):
    TYPE_CHOICES = [
        (0, 'Caixa'),
        (1, 'Online'),
    ]
    PAYMENT_STATUS_CHOICES = [
        (0, 'Não Pago'),
        (1, 'Pago'),
    ]
    PAYMENT_METHOD_CHOICES = [
        (0, 'Dinheiro'),
        (1, 'Cartão de Crédito'),
        (2, 'Cartão de Débito'),
        (3, 'Pix'),
        (4, 'Boleto'),
    ]
    
    type = models.CharField(max_length=10, choices=TYPE_CHOICES, verbose_name="Tipo")
    payment_status = models.CharField(max_length=10, choices=PAYMENT_STATUS_CHOICES, verbose_name="Status de Pagamento")
    payment_method = models.CharField(max_length=50, choices=PAYMENT_METHOD_CHOICES, verbose_name="Método de Pagamento", default=0)
    where = models.CharField(max_length=255, verbose_name="Local da Venda", null=True, blank=True)
    done_at = models.DateTimeField(auto_now_add=True, verbose_name="Data/Hora da Venda")
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Usuário")
    
    # Produtos e suas quantidades na venda
    products = models.ManyToManyField(Product, through='SaleProduct', verbose_name="Produtos")

    def __str__(self):
        return f"Venda {self.id} - {self.get_type_display()}"

    class Meta:
        verbose_name = "Venda"
        verbose_name_plural = "Vendas"


class SaleProduct(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, verbose_name="Produto")
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE, verbose_name="Venda")
    quantity = models.PositiveIntegerField(verbose_name="Quantidade")
    value = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Valor Unitário", default=0)

    def __str__(self):
        return f"{self.quantity}x {self.product.name} (Venda ID: {self.sale.id})"

    class Meta:
        verbose_name = "Produto da Venda"
        verbose_name_plural = "Produtos da Venda"
