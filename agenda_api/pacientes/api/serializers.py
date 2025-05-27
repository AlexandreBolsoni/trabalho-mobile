from rest_framework import serializers
from pacientes import models

class PacienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Paciente
        data_nascimento = serializers.DateField(input_formats=['%Y-%m-%d', '%d-%m-%Y', '%d/%m/%Y'])
        fields = '__all__'