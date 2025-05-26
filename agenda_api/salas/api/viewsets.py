from rest_framework import viewsets, permissions
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from salas.api.serializers import SalaSerializer
from salas import models


class SalaViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = SalaSerializer
    queryset = models.Sala.objects.all()