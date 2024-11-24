# Generated by Django 5.1.1 on 2024-11-24 15:52

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("event", "0008_alter_transaction_type"),
    ]

    operations = [
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
        migrations.DeleteModel(
            name="ProductSale",
        ),
    ]
