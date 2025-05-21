import 'package:agendamento_app/models/agendamento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  int? pacienteId;
  int? profissionalId;
  int? salaId;
  DateTime? data;
  TimeOfDay? hora;
  String status = 'Pendente';

  List pacientes = [];
  List profissionais = [];
  List salas = [];

  @override
  void initState() {
    super.initState();
    carregarDadosIniciais();
    if (widget.agendamento != null) {
      final a = widget.agendamento!;
      pacienteId = a['paciente'];
      profissionalId = a['profissional'];
      salaId = a['sala'];
      data = DateTime.parse(a['data']);
      hora = TimeOfDay(
        hour: int.parse(a['hora'].split(":")[0]),
        minute: int.parse(a['hora'].split(":")[1]),
      );
      status = a['status'] ?? 'Pendente';
    }
  }

  Future<void> carregarDadosIniciais() async {
    pacientes = await PacienteService.fetchPacientes();
    profissionais = await ProfissionalService.getProfissionais();
    salas = await SalaService.getSalas();
    setState(() {});
  }

  Future<void> salvarAgendamento() async {
    if (!_formKey.currentState!.validate()) return;

    final dados = {
      'paciente': pacienteId,
      'profissional': profissionalId,
      'sala': salaId,
      'data': DateFormat('yyyy-MM-dd').format(data!),
      'hora': hora!.format(context),
      'status': status,
    };

    if (widget.agendamento == null) {
     await AgendamentoService.createAgendamento(Agendamento.fromJson(dados));
    } else {
      await AgendamentoService.updateAgendamento(
        widget.agendamento!['id'],
        Agendamento.fromJson(dados),
      );
    }

    Navigator.pop(context);
  }

  Future<void> _selecionarData() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: data ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
        title: Text(
          widget.agendamento == null
              ? 'Novo Agendamento'
              : 'Editar Agendamento',
        ),
      ),
      body:
          pacientes.isEmpty || profissionais.isEmpty || salas.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      DropdownButtonFormField(
                        value: pacienteId,
                        items:
                            pacientes.map<DropdownMenuItem<int>>((p) {
                              return DropdownMenuItem(
                                value: p['id'],
                                child: Text(p['nome']),
                              );
                            }).toList(),
                        onChanged:
                            (value) => setState(() => pacienteId = value),
                        decoration: InputDecoration(labelText: 'Paciente'),
                        validator:
                            (value) =>
                                value == null ? 'Selecione um paciente' : null,
                      ),
                      DropdownButtonFormField(
                        value: profissionalId,
                        items:
                            profissionais.map<DropdownMenuItem<int>>((p) {
                              return DropdownMenuItem(
                                value: p['id'],
                                child: Text(p['nome']),
                              );
                            }).toList(),
                        onChanged:
                            (value) => setState(() => profissionalId = value),
                        decoration: InputDecoration(labelText: 'Profissional'),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Selecione um profissional'
                                    : null,
                      ),
                      DropdownButtonFormField(
                        value: salaId,
                        items:
                            salas.map<DropdownMenuItem<int>>((s) {
                              return DropdownMenuItem(
                                value: s['id'],
                                child: Text(s['nome_sala']),
                              );
                            }).toList(),
                        onChanged: (value) => setState(() => salaId = value),
                        decoration: InputDecoration(labelText: 'Sala'),
                        validator:
                            (value) =>
                                value == null ? 'Selecione uma sala' : null,
                      ),
                      ListTile(
                        title: Text(
                          data == null
                              ? 'Selecionar Data'
                              : 'Data: ${DateFormat('dd/MM/yyyy').format(data!)}',
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: _selecionarData,
                      ),
                      ListTile(
                        title: Text(
                          hora == null
                              ? 'Selecionar Hora'
                              : 'Hora: ${hora!.format(context)}',
                        ),
                        trailing: Icon(Icons.access_time),
                        onTap: _selecionarHora,
                      ),
                      DropdownButtonFormField(
                        value: status,
                        items:
                            ['Pendente', 'Confirmado', 'Cancelado'].map((s) {
                              return DropdownMenuItem(value: s, child: Text(s));
                            }).toList(),
                        onChanged: (value) => setState(() => status = value!),
                        decoration: InputDecoration(labelText: 'Status'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: salvarAgendamento,
                        child: Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
