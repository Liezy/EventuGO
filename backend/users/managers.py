from django.contrib.auth.models import BaseUserManager

class CustomUserManager(BaseUserManager):
    def create_user(self, email, first_name, last_name, cpf, password=None, **extra_fields):
        if not email:
            raise ValueError('O email é obrigatório')
        email = self.normalize_email(email)
        user = self.model(email=email, first_name=first_name, last_name=last_name, cpf=cpf, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, first_name, last_name, password=None, **extra_fields):
        cpf = "000.000.000-00"  # ou qualquer outro valor padrão que você queira usar
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
    
        if extra_fields.get('is_staff') is not True:
            raise ValueError('O superusuário precisa ter is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('O superusuário precisa ter is_superuser=True.')
    
        return self.create_user(email, first_name, last_name, cpf, password, **extra_fields)

