from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model
from users.models import CustomUser 
from django.core.exceptions import ValidationError

class LoginForm(forms.Form):
    username = forms.CharField(
        max_length=150,  # Limite de comprimento do nome de usuário
        widget=forms.TextInput(
            attrs={
                "placeholder": "Email",
                "class": "form-control"
            }
        ),
        error_messages={
            'required': 'Por favor, insira seu Email.',
        }
    )
    password = forms.CharField(
        widget=forms.PasswordInput(
            attrs={
                "placeholder": "Senha",
                "class": "form-control"
            }
        ),
        error_messages={
            'required': 'Por favor, insira sua senha.',
        }
    )


class SignUpForm(UserCreationForm):
    username = forms.CharField(
        widget=forms.TextInput(
            attrs={
                "placeholder": "Username",
                "class": "form-control"
            }
        ),
        max_length=150,  # Defina o comprimento máximo se necessário
    )
    email = forms.EmailField(
        widget=forms.EmailInput(
            attrs={
                "placeholder": "Email",
                "class": "form-control"
            }
        )
    )
    cpf = forms.CharField(  # Adicionando o campo CPF
        widget=forms.TextInput(
            attrs={
                "placeholder": "CPF",
                "class": "form-control"
            }
        ))
    
    password1 = forms.CharField(
        widget=forms.PasswordInput(
            attrs={
                "placeholder": "Senha",
                "class": "form-control"
            }
        )
    )
    password2 = forms.CharField(
        widget=forms.PasswordInput(
            attrs={
                "placeholder": "Confirme a Senha",
                "class": "form-control"
            }
        )
    )

    class Meta:
        model = CustomUser  # Utilize o CustomUser aqui
        fields = ('username', 'email', 'cpf', 'password1', 'password2')

    def clean_username(self):
        username = self.cleaned_data.get('username')
        if CustomUser.objects.filter(username=username).exists():
            raise ValidationError('Esse nome de usuário já está em uso.')
        return username

    def clean_cpf(self):
        cpf = self.cleaned_data.get('cpf')
        if CustomUser.objects.filter(cpf=cpf).exists():
            raise ValidationError('Esse CPF já está em uso.')
        return cpf