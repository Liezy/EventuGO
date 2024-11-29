from django.urls import path
from .views import login_view, register_user, HomeView, logout_view, EventView, EventEditView, EventCreateView, PerfilView, CompanyViwe, CompanyCreateView, CompanyEditView, AddProductView, EventDetailView, ProductEditView

urlpatterns = [
    path('login/', login_view, name="login"),        
    path('register/', register_user, name="register"), 
    path('logout/', logout_view, name="logout"),
    path('home/', HomeView.as_view(), name="home"), 
    path('eventos/', EventView.as_view(), name="eventos"),
    path('eventDetalhe/<int:pk>/', EventDetailView.as_view(), name="eventDetalhe"),
    path('auth/eventDetalhe/<int:event_id>/', AddProductView.as_view(), name='addProduct'),

    path('produto/editar/<int:pk>/', ProductEditView.as_view(), name='productEdit'),
    path('eventEdit/<int:pk>/', EventEditView.as_view(), name="eventEdit"),
    path('eventCreate/', EventCreateView.as_view(), name="eventCreate"),
    path('perfil/', PerfilView.as_view(), name="perfil"),
    path('company/', CompanyViwe.as_view(), name="company"),
    path('companyCreate/', CompanyCreateView.as_view(), name="companyCreate"),
    path('companyEdit/<int:pk>/', CompanyEditView.as_view(), name="companyEdit"),
]
