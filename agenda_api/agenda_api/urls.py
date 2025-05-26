from django.contrib import admin
from django.urls import path, include
from rest_framework import routers

from pacientes.api.viewsets import PacienteViewSet
from profissionais.api.viewsets import ProfissionalViewSet
from salas.api.viewsets import SalaViewSet
from horarios.api.viewsets import HorarioViewSet
from agendamentos.api.viewsets import AgendamentoViewSet

router = routers.DefaultRouter()
router.register(r'pacientes', PacienteViewSet)
router.register(r'profissionais', ProfissionalViewSet)
router.register(r'salas', SalaViewSet)
router.register(r'horarios', HorarioViewSet)
router.register(r'agendamentos', AgendamentoViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include(router.urls)),
]
