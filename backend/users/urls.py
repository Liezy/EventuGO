from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, CustomLoginView

router = DefaultRouter()
router.register(r'usuarios', UserViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
     path('login/', CustomLoginView.as_view(), name='login'),
]
