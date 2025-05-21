import 'package:flutter/material.dart';
import '../../models/paciente.dart';
import '../../services/paciente_service.dart';
import 'paciente_form.dart';

class PacienteListScreen extends StatefulWidget {
  const PacienteListScreen({super.key});

  @override
  _PacienteListScreenState createState() => _PacienteListScreenState();
}

class _PacienteListScreenState extends State<PacienteListScreen> {
  List<Paciente> pacientes = [];

  @override
  void initState() {
    super.initState();
    carregarPacientes();
  }

  void carregarPacientes() async {
    final data = await PacienteService.fetchPacientes();
    setState(() {
      pacientes = data;
    });
  }

  void deletar(int id) async {
    await PacienteService.deletePaciente(id);
    carregarPacientes();
  }

  void abrirForm([Paciente? paciente]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PacienteFormScreen(paciente: paciente)),
    );
    carregarPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF114B5F),
        title: const Text("Pacientes", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: pacientes.length,
          itemBuilder: (_, index) {
            final p = pacientes[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Tel: ${p.telefone}\nEmail: ${p.email}"),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => abrirForm(p)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => deletar(p.id!)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF028090),
        child: const Icon(Icons.add),
        onPressed: () => abrirForm(),
      ),
    );
  }
}
