from rest_framework import serializers
from agendamentos.models import Agendamento
from horarios.models import Horario






class AgendamentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Agendamento
        fields = '__all__'

    def validate(self, data):
        paciente = data['paciente']
        profissional = data['profissional']
        sala = data['sala']
        data_agendamento = data['data']
        hora_agendamento = data['hora']

        # Verificar se o horário está disponível para o profissional
        disponibilidade = Horario.objects.filter(
            profissional=profissional,
            data=data_agendamento,
            hora_inicio__lte=hora_agendamento,
            hora_fim__gte=hora_agendamento
        ).exists()

        if not disponibilidade:
            raise serializers.ValidationError("Profissional não está disponível nesse horário.")

        # Verificar conflito de horário (já existe outro agendamento no mesmo horário?)
        conflito = Agendamento.objects.filter(
          profissional=profissional,
            data=data_agendamento,
            hora=hora_agendamento
        ).exists()

        if conflito:
            raise serializers.ValidationError("Esse horário já está agendado para o profissional.")

        return data