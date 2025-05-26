from rest_framework import serializers
from salas import models


class SalaSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Sala
        fields = '__all__'