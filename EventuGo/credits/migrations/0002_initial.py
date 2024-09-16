# Generated by Django 5.0.2 on 2024-09-16 00:48

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("credits", "0001_initial"),
        ("evento", "0001_initial"),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name="saldo",
            name="usuario",
            field=models.OneToOneField(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="saldo",
                to=settings.AUTH_USER_MODEL,
            ),
        ),
        migrations.AddField(
            model_name="transacao",
            name="evento",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="transacoes",
                to="evento.evento",
            ),
        ),
        migrations.AddField(
            model_name="transacao",
            name="usuario",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="transacoes",
                to=settings.AUTH_USER_MODEL,
            ),
        ),
        migrations.AddField(
            model_name="historicotransacao",
            name="transacao",
            field=models.ForeignKey(
                on_delete=django.db.models.deletion.CASCADE,
                related_name="historico",
                to="credits.transacao",
            ),
        ),
    ]
