from rest_framework import viewsets, status
from django.contrib.auth import get_user_model
from .models import CustomUser, LoginHistory
from .serializers import UserSerializer, LoginHistorySerializer, MyTokenObtainPairSerializer
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from django.contrib.auth import authenticate
from rest_framework.response import Response
from django.contrib.auth.views import LoginView
from django.contrib import messages
from rest_framework import permissions
from rest_framework.views import APIView

class CustomLoginView(LoginView):
    template_name = 'login.html'  # Template para renderizar o formulário de login
    redirect_authenticated_user = True  # Redireciona se o usuário já estiver autenticado

    def form_valid(self, form):
        """Este método é chamado quando o formulário de login é válido"""
        # Primeiro, chamamos o método form_valid padrão para autenticar o usuário
        response = super().form_valid(form)
        
        # Registrar o histórico de login
        user = self.request.user  # Usuário autenticado
        ip_address = self.request.META.get('REMOTE_ADDR')  # Captura o IP do usuário
        LoginHistory.objects.create(user=user, ip_address=ip_address)
        
        # Redireciona para a página inicial após login bem-sucedido
        return response

    def form_invalid(self, form):
        """Este método é chamado quando o formulário de login é inválido"""
        messages.error(self.request, 'Email ou senha incorretos')
        return super().form_invalid(form)
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
        

# View para o login com JWT (personalizada com o serializer)
class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

# View para o refresh token (já fornecido pelo SimpleJWT)
class CustomTokenRefreshView(TokenRefreshView):
    permission_classes = [permissions.IsAuthenticated]
    
class CurrentUserView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        user = request.user

        if user.is_authenticated:
            # Se o usuário estiver autenticado, retornamos os dados dele
            serializer = UserSerializer(user)
            return Response(serializer.data)
        else:
            # Caso contrário, retornamos uma resposta de erro ou dados fictícios
            return Response({"detail": "Usuário não autenticado"}, status=401)