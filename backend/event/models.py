from django.db import models
from django.conf import settings

# Event model to manage events
class Event(models.Model):
    nome = models.CharField(max_length=255)
    descricao = models.TextField()
    data_inicio = models.DateTimeField()
    data_fim = models.DateTimeField()
    organizador = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='events')

    def __str__(self):
        return self.nome
