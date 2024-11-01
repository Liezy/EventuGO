from rest_framework import viewsets
from .models import Event, Balance, Transaction, Product, Sale, ProductSale
from .serializers import EventSerializer, BalanceSerializer, TransactionSerializer, ProductSerializer, SaleSerializer, ProductSaleSerializer

class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer

class BalanceViewSet(viewsets.ModelViewSet):
    queryset = Balance.objects.all()
    serializer_class = BalanceSerializer

class TransactionViewSet(viewsets.ModelViewSet):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class SaleViewSet(viewsets.ModelViewSet):
    queryset = Sale.objects.all()
    serializer_class = SaleSerializer

class ProductSaleViewSet(viewsets.ModelViewSet):
    queryset = ProductSale.objects.all()
    serializer_class = ProductSaleSerializer