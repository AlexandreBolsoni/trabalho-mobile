import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      // Remove fillColor para ficar igual ao formulário de agendamento (sem fundo branco)
    );
  }

  void salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final novo = Paciente(
      nome: nomeController.text.trim(),
      dataNascimento: dataController.text.trim(),
      telefone: telefoneController.text.trim(),
      email: emailController.text.trim(),
    );

    if (widget.paciente == null) {
      await PacienteService.addPaciente(novo);
    } else {
      await PacienteService.updatePaciente(widget.paciente!.id!, novo);
    }

    Navigator.pop(context);
  }

  void _formatarData(String value) {
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 8) {
      final formatada = '${digitsOnly.substring(0, 4)}-${digitsOnly.substring(4, 6)}-${digitsOnly.substring(6, 8)}';
      dataController.value = TextEditingValue(
        text: formatada,
        selection: TextSelection.collapsed(offset: formatada.length),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF1), // Mantive o fundo leve para não destoar
      appBar: AppBar(
        title: Text(widget.paciente == null ? 'Novo Paciente' : 'Editar Paciente'),
        // Removi cor custom para usar cor padrão do tema, igual agendamento
        // Se quiser, pode manter color customizado aqui também
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                controller: dataController,
                decoration: _inputDecoration('Data de nascimento (YYYY-MM-DD)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _formatarData,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe a data';
                  try {
                    DateFormat('yyyy-MM-dd').parseStrict(v);
                  } catch (_) {
                    return 'Data inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: telefoneController,
                decoration: _inputDecoration('Telefone'),
                keyboardType: TextInputType.phone,
                onChanged: _formatarTelefone,
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
                icon: const Icon(Icons.save),
                label: const Text("Salvar", style: TextStyle(fontSize: 16)),
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // Não setei cor fixa para o botão, vai usar cor padrão do tema, igual agendamento
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
