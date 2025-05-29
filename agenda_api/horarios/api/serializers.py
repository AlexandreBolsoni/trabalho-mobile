# serializers.py
from rest_framework import serializers
from horarios.models import Horario
from profissionais.api.serializers import  ProfissionalSerializer# crie esse serializer se ainda não existir

from profissionais.models import Profissional  # certifique-se de importar

class HorarioSerializer(serializers.ModelSerializer):
    profissional = ProfissionalSerializer(read_only=True)
    profissional_id = serializers.PrimaryKeyRelatedField(
        queryset=Profissional.objects.all(), source='profissional', write_only=True
    )

    class Meta:
        model = Horario
        fields = '__all__'
