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
  TextEditingController localizacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sala != null) {
      nomeController.text = widget.sala!['nome'];
      localizacaoController.text = widget.sala!['localizacao'];
    }
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      final sala = {
        'nome': nomeController.text,
        'localizacao': localizacaoController.text,
      };

      final isEdit = widget.sala != null;
      final url = isEdit
          ? 'http://127.0.0.1:8000/api/salas/${widget.sala!['id_sala']}/'
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
              _buildTextField('Nome', nomeController),
              _buildTextField('Localização', localizacaoController),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
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
