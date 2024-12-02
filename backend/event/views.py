from rest_framework import viewsets
from rest_framework.response import Response

from .models import Event, Balance, Transaction, Product, Sale, SaleProduct
from .serializers import (
    EventSerializer,
    BalanceSerializer,
    TransactionSerializer,
    ProductSerializer,
    SaleSerializer,
    SaleProductSerializer,
)

# ViewSet para gerenciar eventos
class EventViewSet(viewsets.ModelViewSet):
    """
    Gerencia as operações de CRUD para os Eventos.
    """
    queryset = Event.objects.all()
    serializer_class = EventSerializer

# ViewSet para gerenciar saldos
class BalanceViewSet(viewsets.ModelViewSet):
    """
    Gerencia as operações de CRUD para os Saldos.
    """
    queryset = Balance.objects.all()
    serializer_class = BalanceSerializer

# ViewSet para gerenciar transações
class TransactionViewSet(viewsets.ModelViewSet):
    """
    Gerencia as operações de CRUD para as Transações.
    """
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer

# ViewSet para gerenciar produtos
class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def list(self, request, *args, **kwargs):
        event_id = request.query_params.get('event_id')
        if event_id:
            products = Product.objects.filter(events__id=event_id)  # Filtra produtos por evento
        else:
            products = Product.objects.all()

        serializer = self.get_serializer(products, many=True)
        return Response(serializer.data)

# ViewSet para gerenciar vendas
class SaleViewSet(viewsets.ModelViewSet):
    """
    Gerencia as operações de CRUD para as Vendas.
    """
    queryset = Sale.objects.all()
    serializer_class = SaleSerializer

# ViewSet para gerenciar vendas de produtos
class SaleProductViewSet(viewsets.ModelViewSet):
    """
    Gerencia as operações de CRUD para os Produtos vinculados a uma Venda.
    """
    queryset = SaleProduct.objects.all()
    serializer_class = SaleProductSerializer
