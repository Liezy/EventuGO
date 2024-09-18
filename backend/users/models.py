from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone

class Customer(models.Model):  # Cliente
    uid = models.UUIDField(primary_key=True, editable=False)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    cpf = models.CharField(max_length=11)  
    passwd_hash = models.CharField(max_length=255)
    phone = models.CharField(max_length=15) 
    address = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    birth_date = models.DateField()
    last_access = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.first_name} {self.last_name}'

class Employee(models.Model):  # Funcionário
    uid = models.UUIDField(primary_key=True, editable=False)
    fullname = models.CharField(max_length=255)
    passwd_hash = models.CharField(max_length=255)
    type = models.CharField(max_length=50)  
    created_at = models.DateTimeField(auto_now_add=True)
    active = models.BooleanField(default=True)
    enterprise = models.ForeignKey(Empresa, on_delete=models.CASCADE)

    def __str__(self):
        return self.fullname

class EmpLoginHistory(models.Model):
    uid = models.UUIDField(primary_key=True, editable=False)
    ip_address = models.GenericIPAddressField()
    time = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(Employee, on_delete=models.CASCADE)

    def __str__(self):
        return f'Login from {self.ip_address} at {self.time}'
