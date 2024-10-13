from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from users.views import MyTokenObtainPairView
from django.shortcuts import redirect


urlpatterns = [
    path('admin/', admin.site.urls),
    path('event/', include('event.urls')),
    path('users/', include('users.urls')),
    path('company/', include('company.urls')),
    path('token/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/', include('authentication.urls')),  # Inclui o app de autenticação
    path('', lambda request: redirect('home')), 
]
