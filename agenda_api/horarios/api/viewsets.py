from rest_framework import viewsets, permissions
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from horarios.api.serializers import HorarioSerializer
from horarios import models


class HorarioViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = HorarioSerializer
    queryset = models.Horario.objects.all()