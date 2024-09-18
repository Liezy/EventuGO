from django.shortcuts import render
from .models import Company
from .serializers import CompanySerializer

# Create your views here.

class CompanyViewSet(viewsets.ModelViewset)
    queryset = Company.objects.all()
    serializer_class = CompanySerializer