from rest_framework import viewsets
from django.contrib.auth import get_user_model
from .models import CustomUser, LoginHistory
from .serializers import UserSerializer, LoginHistorySerializer
from django.contrib.auth.views import LoginView
from django.contrib import messages


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

class LoginHistoryViewSet(viewsets.ModelViewSet):
    queryset = LoginHistory.objects.all()
    serializer_class = LoginHistorySerializer
