from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model
from users.models import CustomUser 
from event.models import Event, Product
from company.models import Company
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
    
        
class EventForm(forms.ModelForm):
    company = forms.ModelChoiceField(
        queryset=Company.objects.all(), 
        widget=forms.Select(attrs={'class': 'form-control'}),  
        label='Empresa',  
        empty_label="Selecione uma empresa",  
        required=True  
    )

    class Meta:
        model = Event
        fields = ['name', 'description', 'type', 'start_date', 'end_date', 'company']
        widgets = {
            'start_date': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'end_date': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'description': forms.Textarea(attrs={'rows': 4, 'placeholder': 'Descreva o evento...'}),
        }
        labels = {
            'name': 'Nome do Evento',
            'description': 'Descrição',
            'type': 'Tipo',
            'start_date': 'Data de Início',
            'end_date': 'Data de Término',
            'company': 'Empresa',
        }
        
class CompanyForm(forms.ModelForm):
    class Meta:
        model = Company
        fields = ['name', 'ico_url', 'cnpj']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Nome da Empresa'}),
            'ico_url': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'URL do Ícone'}),
            'cnpj': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'CNPJ'}),
        }
        labels = {
            'name': 'Nome da Empresa',
            'ico_url': 'Ícone URL',
            'cnpj': 'CNPJ',
        }
        
class ProductForm(forms.ModelForm):
    class Meta:
        model = Product
        fields = ['name', 'description', 'value', 'qtd_stock', 'image']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 3, 'placeholder': 'Descrição do produto...'}),
            'value': forms.NumberInput(attrs={'placeholder': 'R$'}),
            'qtd_stock': forms.NumberInput(attrs={'placeholder': 'Quantidade em estoque'}),
            'image': forms.ClearableFileInput(attrs={'accept': 'image/*'})
        }
        