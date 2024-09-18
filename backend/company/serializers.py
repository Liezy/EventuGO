from rest_framework import Serializers
from .models import Company

class CompanySerializer():
    class Meta:
        model = Company
        fields = ['id', 'name', 'cnpj', 'ico_url', 'created_at']