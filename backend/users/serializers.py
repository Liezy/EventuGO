from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from .models import CustomUser, LoginHistory

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ['uid', 'first_name', 'last_name', 'cpf', 'email', 'phone', 'address', 'is_active', 'created_at', 'birth_date', 'user_type', 'password']
    
    def create(self, validated_data):
        validated_data['password'] = make_password(validated_data['password'])  # Hasheia a senha
        return super().create(validated_data)

class LoginHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = LoginHistory
        fields = ['id', 'ip_address', 'time', 'user']
