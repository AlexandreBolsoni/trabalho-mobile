import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalaForm extends StatefulWidget {
  final Map? sala;

  const SalaForm({super.key, this.sala});

  @override
  State<SalaForm> createState() => _SalaFormState();
}
class _SalaFormState extends State<SalaForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController andarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sala != null) {
      nomeController.text = widget.sala!['nome_sala'] ?? '';
      andarController.text = widget.sala!['andar']?.toString() ?? '';
    }
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      final sala = {
        'nome_sala': nomeController.text,
        'andar': int.tryParse(andarController.text) ?? 0,
      };

      final isEdit = widget.sala != null;
      final url = isEdit
          ? 'http://127.0.0.1:8000/api/salas/${widget.sala!['id']}/'
          : 'http://127.0.0.1:8000/api/salas/';
      final response = await (isEdit
          ? http.put(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(sala))
          : http.post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(sala)));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar sala.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sala == null ? 'Nova Sala' : 'Editar Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Nome da Sala', nomeController),
              _buildTextField('Andar', andarController, isNumber: true),
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
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : null,
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obrigatório' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
