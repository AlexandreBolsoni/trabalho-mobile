from django.db import models

class Sala(models.Model):
    nome_sala = models.CharField(max_length=50)
    andar = models.IntegerField()

    def __str__(self):
        return f"{self.nome_sala} (Andar {self.andar})"