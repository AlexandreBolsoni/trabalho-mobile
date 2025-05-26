from rest_framework import serializers
from pacientes import models

class PacienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Paciente
        fields = '__all__'