from django.db import models

# ====================
# MODELO: Paciente
# ====================
class Paciente(models.Model):
    nome = models.CharField(max_length=100)
    data_nascimento = models.DateField()
    telefone = models.CharField(max_length=20)
    email = models.EmailField(max_length=100, unique=True)

    def __str__(self):
        return self.nome

# ====================
# MODELO: Profissional
# ====================
class Profissional(models.Model):
    nome = models.CharField(max_length=100)
    especialidade = models.CharField(max_length=100)
    telefone = models.CharField(max_length=20)
    email = models.EmailField(max_length=100, unique=True)

    def __str__(self):
        return f"{self.nome} - {self.especialidade}"

# ====================
# MODELO: Sala
# ====================
class Sala(models.Model):
    nome_sala = models.CharField(max_length=50)
    andar = models.IntegerField()

    def __str__(self):
        return f"{self.nome_sala} (Andar {self.andar})"

# ====================
# MODELO: Horário Disponível
# ====================
class HorarioDisponivel(models.Model):
    profissional = models.ForeignKey(Profissional, on_delete=models.CASCADE)
    data = models.DateField()
    hora_inicio = models.TimeField()
    hora_fim = models.TimeField()

    def __str__(self):
        return f"{self.profissional.nome} - {self.data} ({self.hora_inicio} às {self.hora_fim})"

# ====================
# MODELO: Agendamento
# ====================
class Agendamento(models.Model):
    STATUS_CHOICES = [
        ('pendente', 'Pendente'),
        ('confirmado', 'Confirmado'),
        ('cancelado', 'Cancelado'),
    ]

    paciente = models.ForeignKey(Paciente, on_delete=models.CASCADE)
    profissional = models.ForeignKey(Profissional, on_delete=models.CASCADE)
    sala = models.ForeignKey(Sala, on_delete=models.CASCADE)
    data = models.DateField()
    hora = models.TimeField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pendente')

    def __str__(self):
        return f"{self.data} {self.hora} - {self.profissional.nome} com {self.paciente.nome} [{self.status}]"
