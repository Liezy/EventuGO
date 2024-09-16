from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, UserProfileViewSet, LoginHistoryViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'user-profiles', UserProfileViewSet)
router.register(r'login-history', LoginHistoryViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
