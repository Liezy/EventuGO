# Generated by Django 5.1.1 on 2024-11-25 02:58

import django.db.models.deletion
import uuid
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("company", "0001_initial"),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name="Event",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=255, verbose_name="Nome")),
                ("description", models.TextField(verbose_name="Descrição")),
                ("type", models.CharField(max_length=50, verbose_name="Tipo")),
                ("start_date", models.DateTimeField(verbose_name="Data de Início")),
                ("end_date", models.DateTimeField(verbose_name="Data de Término")),
                (
                    "company",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="company.company",
                        verbose_name="Empresa",
                    ),
                ),
            ],
            options={
                "verbose_name": "Evento",
                "verbose_name_plural": "Eventos",
            },
        ),
        migrations.CreateModel(
            name="Balance",
            fields=[
                (
                    "uid",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                        verbose_name="UID",
                    ),
                ),
                (
                    "currency",
                    models.DecimalField(
                        decimal_places=2, max_digits=10, verbose_name="Saldo"
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to=settings.AUTH_USER_MODEL,
                        verbose_name="Usuário",
                    ),
                ),
                (
                    "event",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="event.event",
                        verbose_name="Evento",
                    ),
                ),
            ],
            options={
                "verbose_name": "Saldo",
            },
        ),
        migrations.CreateModel(
            name="Product",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=255, verbose_name="Nome")),
                (
                    "description",
                    models.TextField(blank=True, null=True, verbose_name="Descrição"),
                ),
                (
                    "value",
                    models.DecimalField(
                        decimal_places=2, max_digits=10, verbose_name="Valor"
                    ),
                ),
                (
                    "qtd_stock",
                    models.PositiveIntegerField(verbose_name="Quantidade em Estoque"),
                ),
                ("is_active", models.BooleanField(default=True, verbose_name="Ativo")),
                (
                    "events",
                    models.ManyToManyField(
                        blank=True,
                        related_name="products",
                        to="event.event",
                        verbose_name="Eventos",
                    ),
                ),
            ],
            options={
                "verbose_name": "Produto",
                "verbose_name_plural": "Produtos",
            },
        ),
        migrations.CreateModel(
            name="Sale",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "type",
                    models.CharField(
                        choices=[(0, "Caixa"), (1, "Online")],
                        max_length=10,
                        verbose_name="Tipo",
                    ),
                ),
                (
                    "payment_status",
                    models.CharField(
                        choices=[(0, "Não Pago"), (1, "Pago")],
                        max_length=10,
                        verbose_name="Status de Pagamento",
                    ),
                ),
                (
                    "payment_method",
                    models.CharField(
                        choices=[
                            (0, "Dinheiro"),
                            (1, "Cartão de Crédito"),
                            (2, "Cartão de Débito"),
                            (3, "Pix"),
                            (4, "Boleto"),
                        ],
                        default=0,
                        max_length=50,
                        verbose_name="Método de Pagamento",
                    ),
                ),
                (
                    "where",
                    models.CharField(
                        blank=True,
                        max_length=255,
                        null=True,
                        verbose_name="Local da Venda",
                    ),
                ),
                (
                    "done_at",
                    models.DateTimeField(
                        auto_now_add=True, verbose_name="Data/Hora da Venda"
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to=settings.AUTH_USER_MODEL,
                        verbose_name="Usuário",
                    ),
                ),
            ],
            options={
                "verbose_name": "Venda",
                "verbose_name_plural": "Vendas",
            },
        ),
        migrations.CreateModel(
            name="SaleProduct",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("quantity", models.PositiveIntegerField(verbose_name="Quantidade")),
                (
                    "value",
                    models.DecimalField(
                        decimal_places=2,
                        default=0,
                        max_digits=10,
                        verbose_name="Valor Unitário",
                    ),
                ),
                (
                    "product",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="event.product",
                        verbose_name="Produto",
                    ),
                ),
                (
                    "sale",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="event.sale",
                        verbose_name="Venda",
                    ),
                ),
            ],
            options={
                "verbose_name": "Produto da Venda",
                "verbose_name_plural": "Produtos da Venda",
            },
        ),
        migrations.AddField(
            model_name="sale",
            name="products",
            field=models.ManyToManyField(
                through="event.SaleProduct", to="event.product", verbose_name="Produtos"
            ),
        ),
        migrations.CreateModel(
            name="Transaction",
            fields=[
                (
                    "uid",
                    models.UUIDField(
                        default=uuid.uuid4,
                        editable=False,
                        primary_key=True,
                        serialize=False,
                        verbose_name="UID",
                    ),
                ),
                (
                    "value",
                    models.DecimalField(
                        decimal_places=2, max_digits=10, verbose_name="Valor"
                    ),
                ),
                (
                    "type",
                    models.PositiveIntegerField(
                        choices=[(0, "Recarga"), (1, "Compra")], default=0
                    ),
                ),
                ("hash", models.CharField(max_length=255, verbose_name="Hash")),
                (
                    "done_at",
                    models.DateTimeField(
                        auto_now_add=True, verbose_name="Data/Hora de conclusão"
                    ),
                ),
                (
                    "currency",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="event.balance",
                        verbose_name="Valor",
                    ),
                ),
            ],
            options={
                "verbose_name": "Transação",
                "verbose_name_plural": "Transações",
            },
        ),
    ]
