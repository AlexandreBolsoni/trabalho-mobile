from django.db import models
from profissionais.models import Profissional



class Horario(models.Model):
    profissional = models.ForeignKey(Profissional, on_delete=models.CASCADE)
    data = models.DateField()
    hora_inicio = models.TimeField()
    hora_fim = models.TimeField()

    def __str__(self):
        return f"{self.profissional.nome} - {self.data} ({self.hora_inicio} às {self.hora_fim})"