from rest_framework import viewsets, permissions
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from pacientes.api.serializers import PacienteSerializer
from pacientes import models


class PacienteViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = PacienteSerializer
    queryset = models.Paciente.objects.all()