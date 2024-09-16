from django.contrib import admin

from users.models import CustomUser, LoginHistory, UserProfile
# Register your models here.

admin.site.register(CustomUser)
admin.site.register(LoginHistory)
admin.site.register(UserProfile)
