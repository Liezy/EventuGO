from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import CustomUser, LoginHistory

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['uid', 'first_name', 'last_name', 'cpf', 'phone', 'address', 'is_active', 'created_at', 'birth_date', 'user_type']

class LoginHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = LoginHistory
        fields = ['id', 'ip_address', 'time', 'user']
