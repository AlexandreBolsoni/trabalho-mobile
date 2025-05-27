import 'package:flutter/material.dart';
import '../../models/profissional.dart';
import '../../services/profissional_service.dart';

class ProfissionalForm extends StatefulWidget {
  final Profissional? profissional;

  const ProfissionalForm({Key? key, this.profissional}) : super(key: key);

  @override
  State<ProfissionalForm> createState() => _ProfissionalFormState();
}

class _ProfissionalFormState extends State<ProfissionalForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController especialidadeController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.profissional?.nome ?? '');
    especialidadeController = TextEditingController(text: widget.profissional?.especialidade ?? '');
    telefoneController = TextEditingController(text: widget.profissional?.telefone ?? '');
    emailController = TextEditingController(text: widget.profissional?.email ?? '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    especialidadeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      final profissional = Profissional(
        id: widget.profissional?.id ?? 0, // id 0 ou algum valor placeholder
        nome: nomeController.text,
        especialidade: especialidadeController.text,
        telefone: telefoneController.text,
        email: emailController.text,
      );

      try {
        if (widget.profissional == null) {
          await ProfissionalService.addProfissional(profissional);
        } else {
          await ProfissionalService.updateProfissional(profissional.id, profissional);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar profissional: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profissional == null ? 'Novo Profissional' : 'Editar Profissional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: especialidadeController,
                decoration: const InputDecoration(labelText: 'Especialidade'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a especialidade' : null,
              ),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o telefone' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o email' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
