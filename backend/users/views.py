from rest_framework import viewsets
from django.contrib.auth import get_user_model
from .models import CustomUser, LoginHistory
from .serializers import UserSerializer, LoginHistorySerializer

User = get_user_model()

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class LoginHistoryViewSet(viewsets.ModelViewSet):
    queryset = LoginHistory.objects.all()
    serializer_class = LoginHistorySerializer
