from rest_framework import viewsets
from .models import Saldo, Transacao, HistoricoTransacao
from .serializers import SaldoSerializer, TransacaoSerializer, HistoricoTransacaoSerializer

class SaldoViewSet(viewsets.ModelViewSet):
    queryset = Saldo.objects.all()
    serializer_class = SaldoSerializer

class TransacaoViewSet(viewsets.ModelViewSet):
    queryset = Transacao.objects.all()
    serializer_class = TransacaoSerializer

class HistoricoTransacaoViewSet(viewsets.ModelViewSet):
    queryset = HistoricoTransacao.objects.all()
    serializer_class = HistoricoTransacaoSerializer
