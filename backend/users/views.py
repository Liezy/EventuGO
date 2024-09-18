from rest_framework import viewsets
from django.contrib.auth import get_user_model
from .models import Customer, Employee, EmpLoginHistory
from .serializers import CustomerSerializer, EmployeeSerializer, EmpLoginHistorySerializer

User = get_user_model()

class CustomerViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = CustomerSerializer

class EmployeeViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = EmployeeSerializer

class EmpLoginHistoryViewSet(viewsets.ModelViewSet):
    queryset = LoginHistory.objects.all()
    serializer_class = EmpLoginHistorySerializer
