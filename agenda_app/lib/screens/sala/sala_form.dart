import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final sala = Sala(
      id: widget.sala?.id,
      nomeSala: nomeController.text.trim(),
      andar: int.tryParse(andarController.text.trim()) ?? 0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBF1), // mesmo fundo do agendamento
      appBar: AppBar(
        title: Text(widget.sala == null ? 'Nova Sala' : 'Editar Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: _inputDecoration('Nome da Sala'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome da sala' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: andarController,
                decoration: _inputDecoration('Andar'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o andar' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar', style: TextStyle(fontSize: 16)),
                onPressed: salvar,
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
