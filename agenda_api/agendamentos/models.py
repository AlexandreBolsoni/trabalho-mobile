from django.db import models
from pacientes.models import Paciente
from profissionais.models import Profissional
from salas.models import Sala

class Agendamento(models.Model):
    class Status(models.TextChoices):
        PENDENTE = 'pendente', 'Pendente'
        CONFIRMADO = 'confirmado', 'Confirmado'
        CANCELADO = 'cancelado', 'Cancelado'

    paciente = models.ForeignKey(Paciente, on_delete=models.CASCADE)
    profissional = models.ForeignKey(Profissional, on_delete=models.CASCADE)
    sala = models.ForeignKey(Sala, on_delete=models.CASCADE)
    data = models.DateField()
    hora = models.TimeField()
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDENTE
    )

    def __str__(self):
        return f"{self.data} {self.hora} - {self.profissional.nome} com {self.paciente.nome} [{self.get_status_display()}]"
