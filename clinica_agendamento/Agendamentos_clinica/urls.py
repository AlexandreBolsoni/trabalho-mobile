from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    PacienteViewSet,
    ProfissionalViewSet,
    SalaViewSet,
    HorarioDisponivelViewSet,
    AgendamentoViewSet
)

router = DefaultRouter()
router.register(r'pacientes', PacienteViewSet)
router.register(r'profissionais', ProfissionalViewSet)
router.register(r'salas', SalaViewSet)
router.register(r'horarios', HorarioDisponivelViewSet)
router.register(r'agendamentos', AgendamentoViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
