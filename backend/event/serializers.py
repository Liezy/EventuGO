from rest_framework import serializers
from .models import Event

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = ['id', 'nome', 'descricao', 'data_inicio', 'data_fim', 'organizador']
