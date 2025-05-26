from django.db import models

# Create your models here.
class Profissional(models.Model):
    nome = models.CharField(max_length=100)
    especialidade = models.CharField(max_length=100)
    telefone = models.CharField(max_length=20)
    email = models.EmailField(max_length=100, unique=True)

    def __str__(self):
        return f"{self.nome} - {self.especialidade}"
