import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:agendamento_app/models/agendamento.dart';
import 'package:agendamento_app/models/profissional.dart';
import 'package:agendamento_app/models/paciente.dart';
import 'package:agendamento_app/models/sala.dart';
import '../../services/agendamento_service.dart';
import '../../services/paciente_service.dart';
import '../../services/profissional_service.dart';
import '../../services/sala_service.dart';

class AgendamentoFormPage extends StatefulWidget {
  final Map? agendamento;

  const AgendamentoFormPage({super.key, this.agendamento});

  @override
  _AgendamentoFormPageState createState() => _AgendamentoFormPageState();
}

class _AgendamentoFormPageState extends State<AgendamentoFormPage> {
  final _formKey = GlobalKey<FormState>();

  Paciente? paciente;
  Profissional? profissional;
  Sala? sala;
  DateTime? data;
  TimeOfDay? hora;
  String status = 'Pendente';

  final TextEditingController _telefoneController = TextEditingController();

  List<Paciente> pacientes = [];
  List<Profissional> profissionais = [];
  List<Sala> salas = [];

  @override
  void initState() {
    super.initState();
    carregarDadosIniciais();

    if (widget.agendamento != null) {
      final a = widget.agendamento!;
      paciente = a['paciente'];
      profissional = a['profissional'];
      sala = a['sala'];
      data = DateTime.tryParse(a['data'] ?? '');
      final horaSplit = (a['hora'] ?? '').split(":");
      if (horaSplit.length == 2) {
        hora = TimeOfDay(
          hour: int.tryParse(horaSplit[0]) ?? 0,
          minute: int.tryParse(horaSplit[1]) ?? 0,
        );
      }
      final agStatus = (a['status']?.toString().toLowerCase()) ?? 'pendente';
      status = ['confirmado', 'cancelado'].contains(agStatus)
          ? agStatus[0].toUpperCase() + agStatus.substring(1)
          : 'Pendente';

      // Se o agendamento tem telefone, inicializa o controller com ele:
      if (a['telefone'] != null) {
        _telefoneController.text = a['telefone'];
      }
    }
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> carregarDadosIniciais() async {
    pacientes = await PacienteService.fetchPacientes();
    profissionais = await ProfissionalService.getProfissionais();
    salas = await SalaService.fetchSalas();
    setState(() {});
  }
Future<void> salvarAgendamento() async {
  if (!_formKey.currentState!.validate()) return;
  if (data == null || hora == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data e hora devem ser preenchidas')),
    );
    return;
  }

  final agendamento = Agendamento(
  pacienteId: paciente!.id,
  profissionalId: profissional!.id,
  salaId: sala!.id,
  data: DateFormat('yyyy-MM-dd').format(data!),
  hora: '${hora!.hour.toString().padLeft(2, '0')}:${hora!.minute.toString().padLeft(2, '0')}:00',
  status: status.toLowerCase(),
);

if (widget.agendamento == null) {
  await AgendamentoService.createAgendamento(agendamento);
} else {
  await AgendamentoService.updateAgendamento(widget.agendamento!['id'], agendamento);
}

  Navigator.pop(context);
}
  Future<void> _selecionarData() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: data ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selecionada != null) setState(() => data = selecionada);
  }

  Future<void> _selecionarHora() async {
    final selecionada = await showTimePicker(
      context: context,
      initialTime: hora ?? TimeOfDay.now(),
    );
    if (selecionada != null) setState(() => hora = selecionada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agendamento == null
            ? 'Novo Agendamento'
            : 'Editar Agendamento'),
      ),
      body: pacientes.isEmpty || profissionais.isEmpty || salas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<Paciente>(
                      value: paciente,
                      items: pacientes.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.nome),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => paciente = value),
                      decoration: const InputDecoration(
                        labelText: 'Paciente',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Selecione um paciente' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Profissional>(
                      value: profissional,
                      items: profissionais.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.nome),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => profissional = value),
                      decoration: const InputDecoration(
                        labelText: 'Profissional',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Selecione um profissional' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Sala>(
                      value: sala,
                      items: salas.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.nomeSala),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => sala = value),
                      decoration: const InputDecoration(
                        labelText: 'Sala',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Selecione uma sala' : null,
                    ),
                    const SizedBox(height: 16),

                
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        data == null
                            ? 'Selecionar Data (  )'
                            : 'Data: ${DateFormat('dd/MM/yyyy').format(data!)}',
                      ),
                      onPressed: _selecionarData,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        hora == null
                            ? 'Selecionar Hora (  )'
                            : 'Hora: ${hora!.format(context)}',
                      ),
                      onPressed: _selecionarHora,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: status,
                      items: ['Pendente', 'Confirmado', 'Cancelado']
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => status = value!),
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: salvarAgendamento,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
