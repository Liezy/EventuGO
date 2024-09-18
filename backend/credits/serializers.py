from rest_framework import serializers
from .models import Saldo, Transacao, HistoricoTransacao

class SaldoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Saldo
        fields = ['id', 'usuario', 'saldo_atual']

class TransacaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transacao
        fields = ['id', 'usuario', 'event', 'tipo', 'valor', 'data_hora']

class HistoricoTransacaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = HistoricoTransacao
        fields = ['id', 'transacao', 'data_hora']
