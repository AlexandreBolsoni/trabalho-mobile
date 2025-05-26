from rest_framework import viewsets, permissions
from rest_framework.authentication import SessionAuthentication, BasicAuthentication, TokenAuthentication
from profissionais.api.serializers import ProfissionalSerializer
from profissionais import models


class ProfissionalViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = (BasicAuthentication, SessionAuthentication, TokenAuthentication)
    serializer_class  = ProfissionalSerializer
    queryset = models.Profissional.objects.all()