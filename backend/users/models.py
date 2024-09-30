from django.contrib.auth.models import AbstractUser
from django.db import models
import uuid

class CustomUser(AbstractUser):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False, verbose_name="UID")
    first_name = models.CharField(max_length=255, verbose_name="Nome")
    last_name = models.CharField(max_length=255, verbose_name="Sobrenome")
    cpf = models.CharField(max_length=11, unique=True, verbose_name="CPF")  
    phone = models.CharField(max_length=15, verbose_name="Telefone") 
    address = models.TextField(verbose_name="Endereço")
    is_active = models.BooleanField(default=True, verbose_name="Ativo")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    birth_date = models.DateField(verbose_name="Data de Nascimento", null=True, blank=True)

    TYPE_CHOICES = [
        (1, 'Cliente'),
        (2, 'Funcionário'),
        (3, 'Administrador'),
    ]

    user_type = models.SmallIntegerField(choices=TYPE_CHOICES, default=1, verbose_name="Tipo de Usuário")

    # USERNAME_FIELD = 'name'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    class Meta:
        verbose_name = "Usuário"
        verbose_name_plural = "Usuários"

    def __str__(self):
        return f'{self.first_name} {self.last_name}'


class LoginHistory(models.Model):
    ip_address = models.GenericIPAddressField(verbose_name="IP Address")
    time = models.DateTimeField(auto_now_add=True, verbose_name="Hora de Login")
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name="Usuário")

    class Meta:
        verbose_name = "Histórico de Login"
        verbose_name = "Histórico de Login"

    def __str__(self):
        return f'Login from {self.ip_address} at {self.time}'
