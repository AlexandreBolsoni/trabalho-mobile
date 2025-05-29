import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      // Sem fillColor para manter padrão de formulário sem fundo branco
    );
  }

  void _formatarTelefone(String value) {
    String digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);
    String formatted = digits;

    if (digits.length >= 2) {
      formatted = '(${digits.substring(0, 2)}) ';
      if (digits.length >= 7) {
        formatted += '${digits.substring(2, 7)}-${digits.substring(7)}';
      } else if (digits.length > 2) {
        formatted += digits.substring(2);
      }
    }

    telefoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final profissional = Profissional(
      id: widget.profissional?.id ?? 0,
      nome: nomeController.text.trim(),
      especialidade: especialidadeController.text.trim(),
      telefone: telefoneController.text.trim(),
      email: emailController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF1), // Fundo igual ao formulário de paciente/agendamento
      appBar: AppBar(
        title: Text(widget.profissional == null ? 'Novo Profissional' : 'Editar Profissional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: _inputDecoration('Nome'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: especialidadeController,
                decoration: _inputDecoration('Especialidade'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe a especialidade' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: telefoneController,
                decoration: _inputDecoration('Telefone'),
                keyboardType: TextInputType.phone,
                onChanged: _formatarTelefone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o telefone' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe o email'
                    : (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)
                        ? 'Email inválido'
                        : null),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: salvar,
                icon: const Icon(Icons.save),
                label: const Text('Salvar', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
