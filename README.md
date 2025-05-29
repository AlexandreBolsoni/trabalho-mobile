
# 🗓️ Sistema de Agendamento Médico

Sistema completo de agendamento de consultas médicas, com **frontend em Flutter** e **backend em Django REST Framework**. O projeto está estruturado de forma modular, organizado por entidades como Pacientes, Profissionais, Salas, Horários disponíveis e Agendamentos.

---

## 📁 Estrutura do Projeto

```

agenda\_project/
├── agenda\_api/              # Backend Django
│   ├── agenda\_api/          # Configurações do projeto
│   ├── agendamentos/        # App Django para agendamentos
│   ├── horarios/            # App Django para horários disponíveis
│   ├── pacientes/           # App Django para pacientes
│   ├── profissionais/       # App Django para profissionais
│   └── salas/               # App Django para salas
│
├── agenda\_app/              # Frontend Flutter
│   ├── models/              # Modelos de dados
│   ├── screens/             # Telas organizadas por entidade
│   ├── services/            # Integração com a API
│   └── main.dart            # Ponto de entrada


---

## 🧠 Descrição Geral

O sistema permite:
- Registro de profissionais e horários disponíveis
- Cadastro de pacientes
- Definição de salas de atendimento
- Agendamento de consultas com **validação de conflitos de horário**
- Edição e cancelamento de agendamentos

---

## 💡 Funcionalidades

| Módulo        | Funcionalidades                                                                 |
|---------------|----------------------------------------------------------------------------------|
| Paciente      | CRUD, máscara de telefone, busca por nome/email                                 |
| Profissional  | CRUD, especialidades, agenda vinculada                                           |
| Sala          | Cadastro e organização por andar                                                |
| Horário       | Definição de disponibilidade, evitando sobreposição                             |
| Agendamento   | CRUD, validação de horário conforme profissional e status                       |

---

## 🗃️ Modelo Relacional (ER)

> O sistema segue o modelo relacional abaixo, com integridade entre agendamentos, horários, profissionais e salas.

![Diagrama ER]([path/to/diagrama.png](https://github.com/AlexandreBolsoni/trabalho-mobile/blob/main/Diagrama%20Agenda.png)) <!-- Substitua com o caminho correto no GitHub -->

---

## 🚀 Como Executar

### 📦 Backend - Django

```bash
# 1. Crie e ative o ambiente virtual
python -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows

# 2. Instale as dependências
pip install -r requirements.txt

# 3. Aplique as migrações
python manage.py migrate

# 4. Rode o servidor local
python manage.py runserver
````

### 📱 Frontend - Flutter

```bash
# 1. Instale as dependências
flutter pub get

# 2. Execute o app
flutter run
```

---

## 📂 Estrutura Flutter

```
lib/
├── models/                  # Definição dos modelos (DTOs)
├── screens/
│   ├── agendamento/         # Formulário e lista de agendamentos
│   ├── horario/             # Cadastro de horários disponíveis
│   ├── paciente/            # Cadastro e listagem de pacientes
│   ├── profissional/        # Profissionais da clínica
│   └── sala/                # Definição de salas
├── services/                # Conexão com a API
└── main.dart
```

---

## 📌 Anotações Técnicas

### 🛡️ Validações importantes:

* **Agendamento**: deve estar dentro dos horários disponíveis do profissional.
* **Horário disponível**: não pode haver sobreposição para o mesmo profissional.
* **Busca de pacientes**: por nome ou email (planejado).
* **Status do agendamento**: pode ser implementado como `ENUM` (Pendente, Confirmado, Cancelado...).

---

## 📈 Melhorias Futuras

* Autenticação (token JWT)
* Filtro por data e profissional
* Geração de relatórios
* Upload de foto dos pacientes
* Interface web administrativa

---

## 🪪 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais detalhes.

---

Desenvolvido com 💙 por \Alexandre Hackbardt Bolsoni & Heitor usando **Flutter** e **Django**.

```

---

Se quiser, posso montar o arquivo real `README.md` com os caminhos corrigidos (ex: imagem do diagrama) e te enviar para download. Deseja que eu gere?
```
