import 'package:flutter/material.dart';
import '../../models/horario_disponivel.dart';
import '../../services/horario_service.dart';
import 'horario_form.dart';

class HorarioListScreen extends StatefulWidget {
  const HorarioListScreen({super.key});

  @override
  _HorarioListScreenState createState() => _HorarioListScreenState();
}

class _HorarioListScreenState extends State<HorarioListScreen> {
  List<HorarioDisponivel> horarios = [];

  @override
  void initState() {
    super.initState();
    carregarHorarios();
  }

  void carregarHorarios() async {
    final data = await HorarioService.fetchHorarios();
    setState(() {
      horarios = data;
    });
  }

  void deletar(int id) async {
    await HorarioService.deleteHorario(id);
    carregarHorarios();
  }

  void abrirForm([HorarioDisponivel? horario]) async {
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
        title: const Text("Horários Disponíveis", style: TextStyle(color: Colors.white)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      onPressed: () => deletar(h.profissional?.id ?? 0),
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
