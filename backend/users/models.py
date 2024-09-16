from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    organizador_evento = models.BooleanField(default=False)

    def __str__(self):
        return self.username

# UserProfile: perfil adicional associado ao CustomUser
class UserProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='profile')
    nome = models.CharField(max_length=265, blank=True)
    foto = models.ImageField(upload_to='foto_perfil/', blank=True, null=True)
    telefone = models.CharField(max_length=15, blank=True, null=True)
    endereco = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f'Perfil de {self.user.username}'

# LoginHistory: histórico de logins do usuário, incluindo IP e data/hora
class LoginHistory(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='login_history')
    login_time = models.DateTimeField(default=timezone.now)
    ip_address = models.GenericIPAddressField()

    def __str__(self):
        return f'{self.user.username} - Login em {self.login_time}'
