from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Customer, Employee, EmpLoginHistory


User = get_user_model()

class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['uid', 'first_name', 'last_name', 'cpf', 'passwd_hash', 'phone', 'address', 'created_at', 'birth_date', 'last_access']

class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['uid', 'fullname', 'passwd_hash', 'type', 'created_at', 'active', 'enterprise']

class EmpLoginHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = LoginHistory
        fields = ['uid', 'ip_address', 'time', 'user']
