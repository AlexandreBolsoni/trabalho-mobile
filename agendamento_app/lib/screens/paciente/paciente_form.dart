import 'package:flutter/material.dart';
import '../../models/paciente.dart';
import '../../services/paciente_service.dart';

class PacienteFormScreen extends StatefulWidget {
  final Paciente? paciente;

  PacienteFormScreen({this.paciente});

  @override
  _PacienteFormScreenState createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController dataController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.paciente?.nome ?? '');
    dataController = TextEditingController(text: widget.paciente?.dataNascimento ?? '');
    telefoneController = TextEditingController(text: widget.paciente?.telefone ?? '');
    emailController = TextEditingController(text: widget.paciente?.email ?? '');
  }

  void salvar() async {
    if (_formKey.currentState!.validate()) {
      final novo = Paciente(
        nome: nomeController.text,
        dataNascimento: dataController.text,
        telefone: telefoneController.text,
        email: emailController.text,
      );
      if (widget.paciente == null) {
        await PacienteService.addPaciente(novo);
      } else {
        await PacienteService.updatePaciente(widget.paciente!.id!, novo);
      }
      Navigator.pop(context);
    }
  }

  InputDecoration customInput(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF1),
      appBar: AppBar(
        title: Text(widget.paciente == null ? 'Novo Paciente' : 'Editar Paciente'),
        backgroundColor: const Color(0xFF114B5F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: nomeController, decoration: customInput('Nome'), validator: (v) => v!.isEmpty ? 'Informe o nome' : null),
              const SizedBox(height: 16),
              TextFormField(controller: dataController, decoration: customInput('Data de nascimento (YYYY-MM-DD)'), validator: (v) => v!.isEmpty ? 'Informe a data' : null),
              const SizedBox(height: 16),
              TextFormField(controller: telefoneController, decoration: customInput('Telefone'), validator: (v) => v!.isEmpty ? 'Informe o telefone' : null),
              const SizedBox(height: 16),
              TextFormField(controller: emailController, decoration: customInput('Email'), validator: (v) => v!.isEmpty ? 'Informe o email' : null),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF028090)),
                onPressed: salvar,
                child: const Text("Salvar", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
