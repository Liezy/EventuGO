from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone
import uuid

class CustomUser(AbstractUser):
    uid = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    cpf = models.CharField(max_length=11, unique=True)  
    phone = models.CharField(max_length=15) 
    address = models.TextField()
    active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    birth_date = models.DateField()
    user_type = models.CharField(max_length=50, default='customer')

    USERNAME_FIELD = 'first_name'
    REQUIRED_FIELDS = ['first_name', 'last_name']

    def __str__(self):
        return f'{self.first_name} {self.last_name}'


class EmpLoginHistory(models.Model):
    uid = models.UUIDField(primary_key=True, editable=False)
    ip_address = models.GenericIPAddressField()
    time = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

    def __str__(self):
        return f'Login from {self.ip_address} at {self.time}'
