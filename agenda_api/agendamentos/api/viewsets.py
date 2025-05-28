from rest_framework import viewsets, permissions
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from agendamentos.api.serializers import AgendamentoSerializer
from agendamentos import models
from rest_framework import filters


class AgendamentoViewSet(viewsets.ModelViewSet):
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['paciente__nome', 'profissional__nome']
    ordering_fields = ['data', 'hora']

    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = AgendamentoSerializer

    queryset = models.Agendamento.objects.select_related('profissional', 'paciente', 'sala').all()
