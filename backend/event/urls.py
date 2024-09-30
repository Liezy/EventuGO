from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EventViewSet, BalanceViewSet, TransactionViewSet

router = DefaultRouter()
router.register(r'eventos', EventViewSet)
router.register(r'saldos', BalanceViewSet)
router.register(r'transacoes', TransactionViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
