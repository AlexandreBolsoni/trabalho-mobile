import 'package:flutter/material.dart';
import '../../models/horario.dart';
import '../../services/horario_service.dart';
import 'horario_form.dart';

class HorarioListScreen extends StatefulWidget {
  const HorarioListScreen({super.key});

  @override
  _HorarioListScreenState createState() => _HorarioListScreenState();
}

class _HorarioListScreenState extends State<HorarioListScreen> {
  List<Horario> horarios = [];

  @override
  void initState() {
    super.initState();
    carregarHorarios();
  }

  void carregarHorarios() async {
    final data = await HorarioService.getHorarios();
    setState(() {
      horarios = data;
    });
  }

  Future<void> deletar(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja realmente deletar este horário?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Deletar')),
        ],
      ),
    );

    if (confirm == true) {
      await HorarioService.deleteHorario(id);
      carregarHorarios();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horário deletado com sucesso!')),
      );
    }
  }

  Future<void> abrirForm([Horario? horario]) async {
    if (horario != null) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Editar Horário'),
          content: Text('Deseja editar o horário do profissional: ${horario.profissional?.nome ?? 'Desconhecido'}?\n'
              'Data: ${horario.data}\nInício: ${horario.horaInicio} | Fim: ${horario.horaFim}'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Editar')),
          ],
        ),
      );

      if (proceed != true) {
        return; // Cancelou a edição
      }
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HorarioFormScreen(horario: horario)),
    );
    carregarHorarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Horários Disponíveis",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: horarios.length,
          itemBuilder: (_, index) {
            final h = horarios[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(
                  '${h.profissional?.nome ?? "Sem Profissional"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Data: ${h.data}\nInício: ${h.horaInicio} | Fim: ${h.horaFim}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => abrirForm(h),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (h.profissional?.id != null) {
                          deletar(h.profissional?.id ?? 0);
                          
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('ID do horário não disponível para exclusão')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => abrirForm(),
      ),
    );
  }
}
