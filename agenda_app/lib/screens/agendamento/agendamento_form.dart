import 'package:agendamento_app/models/agendamento.dart';
import 'package:agendamento_app/models/profissional.dart';
import 'package:agendamento_app/models/paciente.dart';
import 'package:agendamento_app/models/sala.dart';
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

  Paciente? paciente;
  Profissional? profissional;
  Sala? sala;
  DateTime? data;
  TimeOfDay? hora;
  String status = 'Pendente';

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
      data = DateTime.parse(a['data']);
      hora = TimeOfDay(
        hour: int.parse(a['hora'].split(":")[0]),
        minute: int.parse(a['hora'].split(":")[1]),
      );
      final agStatus = a['status']?.toString().toLowerCase() ?? 'pendente';
      if (agStatus == 'confirmado') {
        status = 'Confirmado';
      } else if (agStatus == 'cancelado') {
        status = 'Cancelado';
      } else {
        status = 'Pendente';
      }
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
      'paciente': paciente?.toJson(),
      'profissional': profissional?.toJson(),
      'sala': sala?.toJson(),
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
      body: pacientes.isEmpty || profissionais.isEmpty || salas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
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
                      decoration: InputDecoration(labelText: 'Paciente'),
                      validator: (value) =>
                          value == null ? 'Selecione um paciente' : null,
                    ),
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
                      decoration: InputDecoration(labelText: 'Profissional'),
                      validator: (value) =>
                          value == null ? 'Selecione um profissional' : null,
                    ),
                    DropdownButtonFormField<Sala>(
                      value: sala,
                      items: salas.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.nomeSala),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => sala = value),
                      decoration: InputDecoration(labelText: 'Sala'),
                      validator: (value) =>
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
                    DropdownButtonFormField<String>(
                      value: status,
                      items: ['Pendente', 'Confirmado', 'Cancelado']
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                          .toList(),
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
