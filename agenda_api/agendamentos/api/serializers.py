from rest_framework import serializers
from agendamentos.models import Agendamento
from horarios.models import Horario
from profissionais.api.serializers import ProfissionalSerializer
from pacientes.api.serializers import PacienteSerializer

from salas.api.serializers import SalaSerializer  # ⬅️ importe o serializer

class AgendamentoSerializer(serializers.ModelSerializer):
    profissional = ProfissionalSerializer(read_only=True)
    paciente = PacienteSerializer(read_only=True)
    sala = SalaSerializer(read_only=True)  # ⬅️ adicione isso
    profissional_id = serializers.PrimaryKeyRelatedField(
        queryset=Agendamento._meta.get_field('profissional').remote_field.model.objects.all(),
        source='profissional',
        write_only=True
    )
    paciente_id = serializers.PrimaryKeyRelatedField(
        queryset=Agendamento._meta.get_field('paciente').remote_field.model.objects.all(),
        source='paciente',
        write_only=True
    )
    sala_id = serializers.PrimaryKeyRelatedField(  # ⬅️ adicione isso também
        queryset=Agendamento._meta.get_field('sala').remote_field.model.objects.all(),
        source='sala',
        write_only=True
    )

    class Meta:
        model = Agendamento
        fields = '__all__'
