import 'package:flutter/material.dart';
import '../../models/sala.dart';
import '../../services/sala_service.dart';
import 'sala_form.dart';

class SalaListScreen extends StatefulWidget {
  const SalaListScreen({super.key});

  @override
  State<SalaListScreen> createState() => _SalaListScreenState();
}

class _SalaListScreenState extends State<SalaListScreen> {
  List<Sala> salas = [];

  @override
  void initState() {
    super.initState();
    carregarSalas();
  }

  void carregarSalas() async {
    try {
      final data = await SalaService.fetchSalas();
      setState(() {
        salas = data;
      });
    } catch (e) {
      print('Erro ao carregar salas: $e');
    }
  }

  Future<bool> confirmarDialogo(BuildContext context, String titulo, String mensagem) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(titulo),
            content: Text(mensagem),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Não"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Sim"),
              ),
            ],
          ),
        ) ?? false;
  }

  void deletar(int id, String nomeSala) async {
    bool confirmado = await confirmarDialogo(
      context,
      "Confirmar exclusão",
      "Tem certeza que deseja excluir a sala: $nomeSala?",
    );
    if (!confirmado) return;

    try {
      await SalaService.deleteSala(id);
      carregarSalas();
    } catch (e) {
      print('Erro ao deletar sala: $e');
    }
  }

  void abrirForm([Sala? sala]) async {
    if (sala != null) {
      bool confirmado = await confirmarDialogo(
        context,
        "Confirmar edição",
        "Tem certeza que deseja editar a sala: ${sala.nomeSala}?",
      );
      if (!confirmado) return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SalaFormScreen(sala: sala)),
    );
    carregarSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Salas", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: salas.length,
        itemBuilder: (context, index) {
          final s = salas[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(s.nomeSala, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Andar: ${s.andar}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => abrirForm(s),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deletar(s.id!, s.nomeSala),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => abrirForm(),
      ),
    );
  }
}
