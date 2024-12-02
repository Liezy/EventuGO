from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EventViewSet, BalanceViewSet, TransactionViewSet, ProductViewSet, SaleViewSet, SaleProductViewSet

router = DefaultRouter()
router.register(r'eventos', EventViewSet)
router.register(r'saldos', BalanceViewSet)
router.register(r'transacoes', TransactionViewSet)
router.register(r'produtos', ProductViewSet)
router.register(r'vendas', SaleViewSet)
router.register(r'produtos-venda', SaleProductViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
