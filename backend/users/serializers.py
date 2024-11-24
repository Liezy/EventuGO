from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import make_password
from .models import CustomUser, LoginHistory
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.models import User
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, CustomUser):
        # Obtém o token padrão
        token = super().get_token(CustomUser)

        # Adiciona claims customizadas
        token['email'] = CustomUser.email
        token['user_uid'] = str(CustomUser.uid)
        token['first_name'] = CustomUser.first_name
        token['last_name'] = CustomUser.last_name
        token['user_type'] = CustomUser.user_type
        return token
User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = [
            'uid', 'first_name', 'last_name', 'cpf', 'email', 'phone', 
            'address', 'is_active', 'created_at', 'birth_date', 
            'user_type', 'password'
        ]
        extra_kwargs = {
            'password': {'write_only': True},
        }

    def create(self, validated_data):
        """
        Sobrescreve o método de criação para hashear a senha.
        """
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        return super().create(validated_data)

    def update(self, instance, validated_data):
        """
        Sobrescreve o método de atualização para ignorar o campo 'password'.
        """
        validated_data.pop('password', None)  # Remove o password se estiver presente
        return super().update(instance, validated_data)

class LoginHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = LoginHistory
        fields = ['id', 'ip_address', 'time', 'user']
