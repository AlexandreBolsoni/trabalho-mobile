from rest_framework import serializers
from .models import Paciente, Profissional, Sala, HorarioDisponivel, Agendamento

class PacienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Paciente
        fields = '__all__'

class ProfissionalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profissional
        fields = '__all__'

class SalaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sala
        fields = '__all__'

class HorarioDisponivelSerializer(serializers.ModelSerializer):
    class Meta:
        model = HorarioDisponivel
        fields = '__all__'

class AgendamentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Agendamento
        fields = '__all__'

    def validate(self, data):
        profissional = data['id_profissional']
        data_agendamento = data['data']
        hora_agendamento = data['hora']

        # Verificar se o horário está disponível para o profissional
        disponibilidade = HorarioDisponivel.objects.filter(
            id_profissional=profissional,
            data=data_agendamento,
            hora_inicio__lte=hora_agendamento,
            hora_fim__gte=hora_agendamento
        ).exists()

        if not disponibilidade:
            raise serializers.ValidationError("Profissional não está disponível nesse horário.")

        # Verificar conflito de horário (já existe outro agendamento no mesmo horário?)
        conflito = Agendamento.objects.filter(
            id_profissional=profissional,
            data=data_agendamento,
            hora=hora_agendamento
        ).exists()

        if conflito:
            raise serializers.ValidationError("Esse horário já está agendado para o profissional.")

        return data