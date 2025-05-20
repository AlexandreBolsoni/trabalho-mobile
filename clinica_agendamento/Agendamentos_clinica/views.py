from rest_framework import viewsets
from .models import Paciente, Profissional, Sala, HorarioDisponivel, Agendamento
from .serializers import (
    PacienteSerializer, ProfissionalSerializer, SalaSerializer,
    HorarioDisponivelSerializer, AgendamentoSerializer
)

class PacienteViewSet(viewsets.ModelViewSet):
    queryset = Paciente.objects.all()
    serializer_class = PacienteSerializer

class ProfissionalViewSet(viewsets.ModelViewSet):
    queryset = Profissional.objects.all()
    serializer_class = ProfissionalSerializer

class SalaViewSet(viewsets.ModelViewSet):
    queryset = Sala.objects.all()
    serializer_class = SalaSerializer

class HorarioDisponivelViewSet(viewsets.ModelViewSet):
    queryset = HorarioDisponivel.objects.all()
    serializer_class = HorarioDisponivelSerializer

class AgendamentoViewSet(viewsets.ModelViewSet):
    queryset = Agendamento.objects.all()
    serializer_class = AgendamentoSerializer
