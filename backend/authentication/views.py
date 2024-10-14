
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from company.models import Company
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from .forms import LoginForm, SignUpForm, EventForm
from users.models import CustomUser
from event.models import Transaction, Event
from company.models import Company
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import TemplateView, UpdateView, CreateView
from django.db import IntegrityError
from django.urls import reverse_lazy
import json

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

    @method_decorator(csrf_exempt)
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def post(self, request, *args, **kwargs):
        data = json.loads(request.body)
        qr_data = data.get('qr_data')
        
        # Process the QR code data here
        # For example, you might want to create a new transaction:
        # Transaction.objects.create(qr_data=qr_data, user=request.user)
        
        return JsonResponse({'status': 'success', 'message': 'QR code processado com sucesso', 'data': qr_data})
    
    
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

