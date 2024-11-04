
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from company.models import Company
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from .forms import LoginForm, SignUpForm, EventForm, CompanyForm
from users.models import CustomUser
from event.models import Transaction, Event, Balance
from company.models import Company
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import TemplateView, UpdateView, CreateView
from django.db import IntegrityError
from django.contrib import messages
from django.urls import reverse_lazy
import json
import random
import uuid
@method_decorator(csrf_exempt, name='dispatch')
class HomeView(LoginRequiredMixin, TemplateView):
    template_name = 'home/index.html'
    login_url = '/auth/login/'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['total_eventos'] = Event.objects.count()
        context['total_transacoes'] = Transaction.objects.count()
        context['total_usuarios'] = CustomUser.objects.count()
        context['total_empresas'] = Company.objects.count()
        context['transacoes'] = Transaction.objects.all()[:5]  # Limit to 5 most recent transactions
        return context


    def post(self, request, *args, **kwargs):
        data = json.loads(request.body)
        qr_data = data.get('qr_data')
        value = data.get('value')  # Valor da recarga
        event_id = data.get('event_id')  # ID do evento associado

        # Processa o QR code se ele estiver presente
        if qr_data:
            # Aqui você pode processar os dados do QR code conforme necessário
            # Exemplo: criar uma nova transação baseada nos dados do QR
            return JsonResponse({'status': 'success', 'message': 'QR code processado com sucesso', 'data': qr_data})

        # Processa a recarga se o valor e o ID do evento forem fornecidos
        if value and event_id:
            try:
                # Obtém a instância de Balance associada ao usuário e ao evento
                balance = Balance.objects.get(user=request.user, event_id=event_id)

                # Cria a transação de recarga
                transaction = Transaction.objects.create(
                    value=value,
                    type=0,  # 0 representa 'Recarga'
                    hash=uuid.uuid4().hex,  # Um hash único para a transação
                    currency=balance
                )

                return JsonResponse({
                    'status': 'success',
                    'message': 'Recarga processada com sucesso',
                    'transaction_id': transaction.uid
                })
            except Balance.DoesNotExist:
                return JsonResponse({'status': 'error', 'message': 'Saldo não encontrado'}, status=404)
            except Exception as e:
                return JsonResponse({'status': 'error', 'message': str(e)}, status=500)

        return JsonResponse({'status': 'error', 'message': 'Dados inválidos'}, status=400)

    
class EventView(LoginRequiredMixin, TemplateView):
    template_name = 'home/event.html'
    
    def get_context_data(self, **kwargs):
        context =super().get_context_data(**kwargs)
        
        context['events'] = Event.objects.all()
        return context
    
class EventEditView(LoginRequiredMixin, UpdateView):
    model = Event
    template_name = 'home/event_edit.html'
    fields = ['name', 'description', 'type', 'start_date', 'end_date']
    success_url = reverse_lazy('eventos')  # Redireciona para a lista de eventos

    def get(self, request, *args, **kwargs):
        if 'pk' not in kwargs:
            return redirect('eventos')  
        return super().get(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['title'] = f"Editar Evento: {self.object.name}"
      
        context['form'] = self.get_form()
        return context
class EventCreateView(LoginRequiredMixin, CreateView):
    model = Event
    form_class = EventForm
    template_name = 'home/event_create.html'
    success_url = reverse_lazy('eventos')  

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['title'] = "Criar Novo Evento"
        return context
def login_view(request):
    form = LoginForm(request.POST or None)
    user = CustomUser
    msg = None

    if request.method == "POST":

        if form.is_valid():
            username = form.cleaned_data.get("username")
            password = form.cleaned_data.get("password")
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                return redirect('home')
            else:
                msg = 'Credenciais inválidas'
        else:
            msg = 'Erro ao validar o formulário'

    return render(request, "accounts/login.html", {"form": form, "msg": msg})

def logout_view(request):
    logout(request)  # Encerra a sessão do usuário
    return redirect('/auth/login/')

def register_user(request):
    msg = None
    success = False

    if request.method == "POST":
        form = SignUpForm(request.POST)
        if form.is_valid():
            try:
                user = form.save()  # Salva o novo usuário
                username = form.cleaned_data.get("username")
                raw_password = form.cleaned_data.get("password1")
                user = authenticate(username=username, password=raw_password)

                msg = 'Usuário criado - por favor <a href="/auth/login">faça login</a>.'
                success = True

                return redirect("/auth/login/")
            except IntegrityError:
                msg = 'Erro ao criar usuário, CPF ou e-mail já existentes.'
        else:
            msg = 'Formulário não é válido'
    else:
        form = SignUpForm()

    return render(request, "accounts/register.html", {"form": form, "msg": msg, "success": success})
CompanyForm
class PerfilView(LoginRequiredMixin, UpdateView):
    model = CustomUser
    template_name = 'home/perfil.html'
    fields = ['first_name', 'last_name', 'email', 'phone', 'address', 'birth_date']
    success_url = reverse_lazy('perfil')

    def get_object(self, queryset=None):
        return self.request.user

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Lista de capas de card disponíveis
        card_covers = [
            '/static/assets/img/theme/oPai.png',
            '/static/assets/img/theme/dog.png',
            '/static/assets/img/theme/eli.png',
            '/static/assets/img/theme/muri.png',
            '/static/assets/img/theme/icar.png',
        ]
        context['card_cover_aleatoria'] = random.choice(card_covers)
        return context

    def form_valid(self, form):
        messages.success(self.request, 'Perfil atualizado com sucesso!')
        return super().form_valid(form)
    
    
class CompanyViwe(LoginRequiredMixin, TemplateView):
    model = Company
    template_name = 'home/company.html'
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['companies'] = Company.objects.all()  # Passa todas as empresas para o contexto
        return context

class CompanyCreateView(CreateView):
    model = Company
    form_class = CompanyForm
    template_name = 'home/company_create.html'
    success_url = reverse_lazy('company')

    def form_valid(self, form):
        response = super().form_valid(form)
        messages.success(self.request, 'Empresa criada com sucesso!')
        return response
class CompanyEditView(LoginRequiredMixin, UpdateView):
    model = Company
    template_name = 'home/company_edit.html'
    form_class = CompanyForm
    success_url = reverse_lazy('company')  # ou o URL de sucesso que preferir

    def form_valid(self, form):
        # Opcional: mensagens de sucesso ou outra lógica adicional
        messages.success(self.request, 'Empresa atualizada com sucesso!')
        return super().form_valid(form)
