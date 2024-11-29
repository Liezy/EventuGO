from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from django.shortcuts import redirect
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('admin/', admin.site.urls),
    path('event/', include('event.urls')),
    path('users/', include('users.urls')),
    path('company/', include('company.urls')),
    path('auth/', include('authentication.urls')),  # Inclui o app de autenticação
    path('', lambda request: redirect('home')), 
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
