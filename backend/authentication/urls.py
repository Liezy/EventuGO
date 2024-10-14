from django.urls import path
from .views import login_view, register_user, HomeView, logout_view, EventView, EventEditView, EventCreateView

urlpatterns = [
    path('login/', login_view, name="login"),        
    path('register/', register_user, name="register"), 
    path('logout/', logout_view, name="logout"),
    path('home/', HomeView.as_view(), name="home"), 
    path('eventos/', EventView.as_view(), name="eventos"),
    path('eventEdit/<int:pk>/', EventEditView.as_view(), name="eventEdit"),
    path('eventCreate/', EventCreateView.as_view(), name="eventCreate")
]
