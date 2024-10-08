# Generated by Django 5.1.1 on 2024-09-18 19:24

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('company', '0001_initial'),
        ('event', '0002_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='balance',
            options={'verbose_name': 'Saldo'},
        ),
        migrations.AlterModelOptions(
            name='event',
            options={'verbose_name': 'Evento', 'verbose_name_plural': 'Eventos'},
        ),
        migrations.AlterModelOptions(
            name='transaction',
            options={'verbose_name': 'Transação', 'verbose_name_plural': 'Transações'},
        ),
        migrations.AddField(
            model_name='event',
            name='company',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='company.company', verbose_name='Empresa'),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='balance',
            name='currency',
            field=models.DecimalField(decimal_places=2, max_digits=10, verbose_name='Saldo'),
        ),
        migrations.AlterField(
            model_name='balance',
            name='event',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='event.event', verbose_name='Evento'),
        ),
        migrations.AlterField(
            model_name='balance',
            name='uid',
            field=models.UUIDField(editable=False, primary_key=True, serialize=False, verbose_name='UID'),
        ),
        migrations.AlterField(
            model_name='balance',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='Usuário'),
        ),
        migrations.AlterField(
            model_name='event',
            name='description',
            field=models.TextField(verbose_name='Descrição'),
        ),
        migrations.AlterField(
            model_name='event',
            name='end_date',
            field=models.DateTimeField(verbose_name='Data de Término'),
        ),
        migrations.AlterField(
            model_name='event',
            name='name',
            field=models.CharField(max_length=255, verbose_name='Nome'),
        ),
        migrations.AlterField(
            model_name='event',
            name='start_date',
            field=models.DateTimeField(verbose_name='Data de Início'),
        ),
        migrations.AlterField(
            model_name='event',
            name='type',
            field=models.CharField(max_length=50, verbose_name='Tipo'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='currency',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='event.balance', verbose_name='Valor'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='done_at',
            field=models.DateTimeField(auto_now_add=True, verbose_name='Data/Hora de conclusão'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='hash',
            field=models.CharField(max_length=255, verbose_name='Hash'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='type',
            field=models.CharField(max_length=50, verbose_name='Tipo'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='uid',
            field=models.UUIDField(editable=False, primary_key=True, serialize=False, verbose_name='UID'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='value',
            field=models.DecimalField(decimal_places=2, max_digits=10, verbose_name='Valor'),
        ),
    ]
