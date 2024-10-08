from rest_framework import serializers
from .models import Event, Balance, Transaction

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
