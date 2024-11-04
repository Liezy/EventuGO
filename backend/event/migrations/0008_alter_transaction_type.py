# Generated by Django 5.1.1 on 2024-11-04 17:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('event', '0007_sale_where'),
    ]

    operations = [
        migrations.AlterField(
            model_name='transaction',
            name='type',
            field=models.PositiveIntegerField(choices=[(0, 'Recarga'), (1, 'Compra')], default=0),
        ),
    ]