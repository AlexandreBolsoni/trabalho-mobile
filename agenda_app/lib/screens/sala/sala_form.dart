import 'package:flutter/material.dart';
import '../../models/sala.dart';
import '../../services/sala_service.dart';

class SalaFormScreen extends StatefulWidget {
  final Sala? sala;

  const SalaFormScreen({super.key, this.sala});

  @override
  State<SalaFormScreen> createState() => _SalaFormScreenState();
}

class _SalaFormScreenState extends State<SalaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController andarController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.sala?.nomeSala ?? '');
    andarController = TextEditingController(
        text: widget.sala?.andar != null ? widget.sala!.andar.toString() : '');
  }

  Future<void> salvar() async {
    if (_formKey.currentState!.validate()) {
      final sala = Sala(
        id: widget.sala?.id,
        nomeSala: nomeController.text,
        andar: int.tryParse(andarController.text) ?? 0,
      );

      try {
        if (widget.sala == null) {
          await SalaService.addSala(sala);
        } else {
          await SalaService.updateSala(widget.sala!.id!, sala);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar sala')),
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
