from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('Agendamentos_clinica.urls')),  # <--- ISSO É O IMPORTANTE
]
