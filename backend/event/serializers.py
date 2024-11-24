from rest_framework import serializers
from .models import Event, Balance, Transaction, Product, Sale, SaleProduct
from rest_framework.response import Response


class ProductSerializer(serializers.ModelSerializer):
    # Incluindo eventos relacionados ao produto
    events = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'description', 'value', 'qtd_stock', 'is_active', 'events']


class EventSerializer(serializers.ModelSerializer):
    products = ProductSerializer(many=True, read_only=True)  # Inclui produtos relacionados ao evento

    class Meta:
        model = Event
        fields = ['id', 'name', 'description', 'type', 'start_date', 'end_date', 'company', 'products']

class BalanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Balance
        fields = ['uid', 'currency', 'event', 'user']

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ['uid', 'value', 'type', 'hash', 'done_at', 'currency']


        
class SaleProductSerializer(serializers.ModelSerializer):
    product = ProductSerializer()  # Serializa o produto
    value = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)  # Valor unitário na venda

    class Meta:
        model = SaleProduct
        fields = ['product', 'sale', 'quantity', 'value']

class SaleSerializer(serializers.ModelSerializer):
    products = SaleProductSerializer(source='saleproduct_set', many=True)  # Relaciona os produtos à venda

    class Meta:
        model = Sale
        fields = ['id', 'type', 'payment_status', 'done_at', 'user', 'payment_method', 'products']

