from rest_framework import viewsets
from django.contrib.auth import get_user_model
from .models import CustomUser, LoginHistory
from .serializers import UserSerializer, LoginHistorySerializer
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth import authenticate
from rest_framework import status
from rest_framework.response import Response

User = get_user_model()

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
    def create(self, request, *args, **kwargs):
        return super().create(request, *args, **kwargs)

class LoginHistoryViewSet(viewsets.ModelViewSet):
    queryset = LoginHistory.objects.all()
    serializer_class = LoginHistorySerializer

class LoginView(TokenObtainPairView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        password = request.data.get("password")

        # Autenticação usando o e-mail
        user = authenticate(request, username=email, password=password)
        
        if user is not None:
            # Se o usuário for autenticado corretamente, gera o token
            refresh = self.get_tokens_for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }, status=status.HTTP_200_OK)
        else:
            return Response({'detail': 'Usuário ou senha incorretos'}, status=status.HTTP_401_UNAUTHORIZED)