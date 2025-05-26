from rest_framework import serializers
from horarios import models


class HorarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Horario
        fields = '__all__'