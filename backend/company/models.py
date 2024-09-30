from django.db import models

# Create your models here.
class Company(models.Model):
    name = models.CharField(max_length=255, verbose_name="Nome Empresa")
    ico_url = models.URLField(max_length=255, verbose_name="Ícone URL")
    cnpj = models.CharField(max_length=18, verbose_name="CNPJ")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Data/Hora de criação")

    class Meta:
        verbose_name = "Empresa"
        verbose_name_plural = "Empresas"

    def __str__(self):
        return self.name
    