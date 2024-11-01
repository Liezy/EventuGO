from rest_framework import serializers
from .models import Event, Balance, Transaction, Product, Sale, ProductSale

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = ['id', 'name', 'description', 'type', 'start_date', 'end_date', 'company']

class BalanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Balance
        fields = ['uid', 'currency', 'event', 'user']

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ['uid', 'value', 'type', 'hash', 'done_at', 'currency']

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['name', 'description', 'value', 'qtd_stock', 'is_active']

class SaleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sale
        fields = ['type', 'payment_status', 'done_at', 'user', 'payment_method']

class ProductSaleSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductSale
        fields = ['product', 'sale', 'quantity']