import 'package:flutter/material.dart';
import '../../models/paciente.dart';
import '../../services/paciente_service.dart';

class PacienteFormScreen extends StatefulWidget {
  final Paciente? paciente;

  const PacienteFormScreen({super.key, this.paciente});

  @override
  _PacienteFormScreenState createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController dataNascimentoController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.paciente?.nome ?? '');
    dataNascimentoController = TextEditingController(text: widget.paciente?.dataNascimento ?? '');
    telefoneController = TextEditingController(text: widget.paciente?.telefone ?? '');
    emailController = TextEditingController(text: widget.paciente?.email ?? '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    dataNascimentoController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void salvar() async {
    if (_formKey.currentState!.validate()) {
      final paciente = Paciente(
        nome: nomeController.text.trim(),
        dataNascimento: dataNascimentoController.text.trim(), // deve estar no formato YYYY-MM-DD
        telefone: telefoneController.text.trim(),
        email: emailController.text.trim(),
      );

      try {
        if (widget.paciente == null) {
          await PacienteService.addPaciente(paciente);
        } else {
          await PacienteService.updatePaciente(widget.paciente!.id!, paciente);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar paciente: $e')),
        );
      }
    }
  }

  InputDecoration inputDecoracao(String label) {
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
              TextFormField(
                controller: nomeController,
                decoration: inputDecoracao('Nome completo'),
                validator: (value) => value!.isEmpty ? 'Informe o nome do paciente' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dataNascimentoController,
                decoration: inputDecoracao('Data de nascimento (AAAA-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a data de nascimento';
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  return regex.hasMatch(value) ? null : 'Formato inválido (ex: 2000-12-31)';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: telefoneController,
                decoration: inputDecoracao('Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: inputDecoracao('E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o e-mail';
                  final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                  return regex.hasMatch(value) ? null : 'E-mail inválido';
                },
              ),
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
