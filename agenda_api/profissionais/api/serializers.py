from rest_framework import serializers
from profissionais import models


class ProfissionalSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Profissional
        fields = '__all__'  