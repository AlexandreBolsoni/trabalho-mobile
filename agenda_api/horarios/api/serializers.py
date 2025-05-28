# serializers.py
from rest_framework import serializers
from horarios.models import Horario
from profissionais.api.serializers import  ProfissionalSerializer# crie esse serializer se ainda não existir

class HorarioSerializer(serializers.ModelSerializer):
    profissional = ProfissionalSerializer(read_only=True)

    class Meta:
        model = Horario
        fields = '__all__'