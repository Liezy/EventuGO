from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EventViewSet, BalanceViewSet, TransactionViewSet

router = DefaultRouter()
router.register(r'event', EventViewSet)
router.register(r'balance', BalanceViewSet)
router.register(r'transaction', TransactionViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
