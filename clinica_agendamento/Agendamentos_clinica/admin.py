from django.contrib import admin
from .models import Paciente, Profissional, Sala, HorarioDisponivel, Agendamento

admin.site.register(Paciente)
admin.site.register(Profissional)
admin.site.register(Sala)
admin.site.register(HorarioDisponivel)
admin.site.register(Agendamento)
