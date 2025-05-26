import 'package:flutter/material.dart';
import 'agendamento_form.dart';
import '../../services/agendamento_service.dart';
import '../../models/agendamento.dart';


class AgendamentoListPage extends StatefulWidget {
  const AgendamentoListPage({super.key});

  @override
  _AgendamentoListPageState createState() => _AgendamentoListPageState();
}

class _AgendamentoListPageState extends State<AgendamentoListPage> {
  List<Agendamento> agendamentos = [];

  @override
  void initState() {
    super.initState();
    fetchAgendamentos();
  }

  Future<void> fetchAgendamentos() async {
    final data = await AgendamentoService.getAgendamentos();
    setState(() {
      agendamentos = data.cast<Agendamento>();
    });
  }

  void _deleteAgendamento(int id) async {
    await AgendamentoService.deleteAgendamento(id);
    fetchAgendamentos();
  }

  void _navigateToForm([Agendamento? agendamento]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AgendamentoFormPage(agendamento: agendamento?.toJson()),
      ),
    );
    fetchAgendamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamentos'),
      ),
      body: ListView.builder(
        itemCount: agendamentos.length,
        itemBuilder: (context, index) {
          final agendamento = agendamentos[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text('Paciente: ${agendamento.paciente?.nome ?? '---'}'),
              subtitle: Text(
                'Data: ${agendamento.data} - Hora: ${agendamento.hora}\n'
                'Profissional: ${agendamento.profissional?.nome ?? '---'} - '
                'Sala: ${agendamento.sala?.nomeSala ?? '---'}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToForm(agendamento),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAgendamento(agendamento.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => _navigateToForm(),
      ),
    );
  }
}
