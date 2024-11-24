from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, CustomLoginView, CustomTokenObtainPairView, CustomTokenRefreshView, CurrentUserView

router = DefaultRouter()
router.register(r'usuarios', UserViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
    path('api/current-user/', CurrentUserView.as_view(), name='current-user'),
    path('token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
    path('login/', CustomLoginView.as_view(), name='login'),
]
