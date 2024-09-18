from django.contrib import admin

from users.models import Customer, Employee, EmpLoginHistory
# Register your models here.

admin.site.register(Customer)
admin.site.register(Employee)
admin.site.register(EmpLoginHistory)
