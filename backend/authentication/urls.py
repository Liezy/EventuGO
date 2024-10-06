from django.urls import path
from .views import login_view, register_user, HomeView, logout_view

urlpatterns = [
    path('login/', login_view, name="login"),        
    path('register/', register_user, name="register"), 
    path('logout/', logout_view, name="logout"),
    path('home/', HomeView.as_view(), name="home") 
]
