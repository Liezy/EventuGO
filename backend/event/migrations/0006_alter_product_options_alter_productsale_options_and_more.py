# Generated by Django 5.1.1 on 2024-10-13 16:53

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('event', '0005_product_sale_productsale'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='product',
            options={'verbose_name': 'Produto', 'verbose_name_plural': 'Produtos'},
        ),
        migrations.AlterModelOptions(
            name='productsale',
            options={'verbose_name': 'Produto da Venda', 'verbose_name_plural': 'Produtos da Venda'},
        ),
        migrations.AlterModelOptions(
            name='sale',
            options={'verbose_name': 'Venda', 'verbose_name_plural': 'Vendas'},
        ),
        migrations.AddField(
            model_name='sale',
            name='payment_method',
            field=models.CharField(choices=[(0, 'Dinheiro'), (1, 'Cartão de Crédito'), (2, 'Cartão de Débito'), (3, 'Pix'), (4, 'Boleto')], default=0, max_length=50, verbose_name='Método de Pagamento'),
        ),
        migrations.AlterField(
            model_name='product',
            name='description',
            field=models.TextField(blank=True, null=True, verbose_name='Descrição'),
        ),
        migrations.AlterField(
            model_name='product',
            name='is_active',
            field=models.BooleanField(default=True, verbose_name='Ativo'),
        ),
        migrations.AlterField(
            model_name='product',
            name='name',
            field=models.CharField(max_length=255, verbose_name='Nome'),
        ),
        migrations.AlterField(
            model_name='product',
            name='qtd_stock',
            field=models.PositiveIntegerField(verbose_name='Quantidade em Estoque'),
        ),
        migrations.AlterField(
            model_name='product',
            name='value',
            field=models.DecimalField(decimal_places=2, max_digits=10, verbose_name='Valor'),
        ),
        migrations.AlterField(
            model_name='productsale',
            name='product',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='event.product', verbose_name='Produto'),
        ),
        migrations.AlterField(
            model_name='productsale',
            name='quantity',
            field=models.PositiveIntegerField(verbose_name='Quantidade'),
        ),
        migrations.AlterField(
            model_name='productsale',
            name='sale',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='event.sale', verbose_name='Venda'),
        ),
        migrations.AlterField(
            model_name='sale',
            name='done_at',
            field=models.DateTimeField(auto_now_add=True, verbose_name='Data/Hora da Venda'),
        ),
        migrations.AlterField(
            model_name='sale',
            name='payment_status',
            field=models.CharField(choices=[(0, 'Não Pago'), (1, 'Pago')], max_length=10, verbose_name='Status de Pagamento'),
        ),
        migrations.AlterField(
            model_name='sale',
            name='type',
            field=models.CharField(choices=[(0, 'Caixa'), (1, 'Online')], max_length=10, verbose_name='Tipo'),
        ),
        migrations.AlterField(
            model_name='sale',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='Usuário'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='type',
            field=models.CharField(choices=[(0, 'Recarga'), (1, 'Compra')], max_length=50, verbose_name='Tipo'),
        ),
        migrations.AlterModelTable(
            name='product',
            table=None,
        ),
        migrations.AlterModelTable(
            name='productsale',
            table=None,
        ),
        migrations.AlterModelTable(
            name='sale',
            table=None,
        ),
    ]
