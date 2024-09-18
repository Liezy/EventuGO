from django.db import models
from django.conf import settings

class Event(models.Model):
    uid = models.UUIDField(primary_key=True, editable=False)
    name = models.CharField(max_length=255)
    description = models.TextField()
    type = models.CharField(max_length=50)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    enterprise = models.ForeignKey(Enterprise, on_delete=models.CASCADE)

    def __str__(self):
        return self.name

class Balance(models.Model):  
    uid = models.UUIDField(primary_key=True, editable=False)
    currency = models.DecimalField(max_digits=10, decimal_places=2)  
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    user = models.ForeignKey(Customer, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.user} - {self.event}'

class Transaction(models.Model):
    uid = models.UUIDField(primary_key=True, editable=False)
    value = models.DecimalField(max_digits=10, decimal_places=2)
    type = models.CharField(max_length=50)
    hash = models.CharField(max_length=255)
    done_at = models.DateTimeField(auto_now_add=True)
    currency = models.ForeignKey(Balance), on_delete=models.CASCADE)  

    def __str__(self):
        return f'{self.type} - {self.value}'
