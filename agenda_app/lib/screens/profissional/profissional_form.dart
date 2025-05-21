import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfissionalForm extends StatefulWidget {
  final Map? profissional;

  const ProfissionalForm({super.key, this.profissional});

  @override
  State<ProfissionalForm> createState() => _ProfissionalFormState();
}

class _ProfissionalFormState extends State<ProfissionalForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController especialidadeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.profissional != null) {
      nomeController.text = widget.profissional!['nome'];
      especialidadeController.text = widget.profissional!['especialidade'];
      telefoneController.text = widget.profissional!['telefone'];
      emailController.text = widget.profissional!['email'];
    }
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      final profissional = {
        'nome': nomeController.text,
        'especialidade': especialidadeController.text,
        'telefone': telefoneController.text,
        'email': emailController.text,
      };

      final isEdit = widget.profissional != null;
      final url = isEdit
          ? 'http://127.0.0.1:8000/api/profissionais/${widget.profissional!['id_profissional']}/'
          : 'http://127.0.0.1:8000/api/profissionais/';
      final response = await (isEdit
          ? http.put(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(profissional))
          : http.post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(profissional)));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar profissional.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profissional == null
            ? 'Novo Profissional'
            : 'Editar Profissional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Nome', nomeController),
              _buildTextField('Especialidade', especialidadeController),
              _buildTextField('Telefone', telefoneController),
              _buildTextField('Email', emailController, tipo: TextInputType.emailAddress),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType tipo = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: tipo,
        validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
