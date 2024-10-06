from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect


urlpatterns = [
    path('admin/', admin.site.urls),
    path('event/', include('event.urls')),
    path('users/', include('users.urls')),
    path('company/', include('company.urls')),
    path('auth/', include('authentication.urls')),  # Inclui o app de autenticação
     path('', lambda request: redirect('login')), 
]
