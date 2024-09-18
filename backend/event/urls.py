from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EventViewSet

router = DefaultRouter()
router.register(r'event', EventViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]
