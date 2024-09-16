from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import SaldoViewSet, TransacaoViewSet, HistoricoTransacaoViewSet

router = DefaultRouter()
router.register(r'saldos', SaldoViewSet)
router.register(r'transacoes', TransacaoViewSet)
router.register(r'historico-transacoes', HistoricoTransacaoViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
