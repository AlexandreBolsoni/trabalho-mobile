from django.db import models

class Paciente(models.Model):
    nome = models.CharField(max_length=100)
    data_nascimento = models.DateField()
    telefone = models.CharField(max_length=20)
    email = models.EmailField(max_length=100, unique=True)

    def __str__(self):
        return self.nome
