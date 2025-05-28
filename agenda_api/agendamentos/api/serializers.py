from rest_framework import serializers
from agendamentos.models import Agendamento
from horarios.models import Horario
from profissionais.api.serializers import ProfissionalSerializer
from pacientes.api.serializers import PacienteSerializer


class AgendamentoSerializer(serializers.ModelSerializer):
    profissional = ProfissionalSerializer(read_only=True)
    paciente = PacienteSerializer(read_only=True)
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

    class Meta:
        model = Agendamento
        fields = '__all__'

    def validate(self, data):
        profissional = data['profissional']
        paciente = data['paciente']
        sala = data['sala']
        data_agendamento = data['data']
        hora_agendamento = data['hora']

        # Verifica se o profissional está disponível nesse horário
        disponibilidade = Horario.objects.filter(
            profissional=profissional,
            data=data_agendamento,
            hora_inicio__lte=hora_agendamento,
            hora_fim__gte=hora_agendamento
        ).exists()

        if not disponibilidade:
            raise serializers.ValidationError("Profissional não está disponível nesse horário.")

        # Verifica se já existe agendamento nesse horário
        conflito = Agendamento.objects.filter(
            profissional=profissional,
            data=data_agendamento,
            hora=hora_agendamento
        ).exists()

        if conflito:
            raise serializers.ValidationError("Esse horário já está agendado para o profissional.")

        return data
