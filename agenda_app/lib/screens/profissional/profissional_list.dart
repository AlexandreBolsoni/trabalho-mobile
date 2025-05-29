import 'package:flutter/material.dart';
import 'profissional_form.dart';
import '../../models/profissional.dart';
import '../../services/profissional_service.dart';

class ProfissionalList extends StatefulWidget {
  const ProfissionalList({super.key});

  @override
  State<ProfissionalList> createState() => _ProfissionalListState();
}

class _ProfissionalListState extends State<ProfissionalList> {
  List<Profissional> profissionais = [];

  @override
  void initState() {
    super.initState();
    carregarProfissionais();
  }

  Future<void> carregarProfissionais() async {
    try {
      final lista = await ProfissionalService.getProfissionais();
      setState(() {
        profissionais = lista;
      });
    } catch (e) {
      // Pode mostrar um snackbar ou algo para o usuário
      print('Erro ao carregar profissionais: $e');
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

  Future<void> excluirProfissional(int id, String nome) async {
    bool confirmado = await confirmarDialogo(
      context,
      "Confirmar exclusão",
      "Tem certeza que deseja excluir o profissional: $nome?",
    );
    if (!confirmado) return;

    try {
      await ProfissionalService.deleteProfissional(id);
      carregarProfissionais();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir profissional')),
      );
    }
  }

  void abrirFormulario([Profissional? profissional]) async {
    if (profissional != null) {
      bool confirmado = await confirmarDialogo(
        context,
        "Confirmar edição",
        "Tem certeza que deseja editar o profissional: ${profissional.nome}?",
      );
      if (!confirmado) return;
    }

    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfissionalForm(profissional: profissional),
      ),
    );

    if (resultado == true) {
      carregarProfissionais();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profissionais'),
      ),
      body: ListView.builder(
        itemCount: profissionais.length,
        itemBuilder: (context, index) {
          final p = profissionais[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(p.nome),
              subtitle: Text('${p.especialidade} | ${p.email}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => abrirFormulario(p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => excluirProfissional(p.id, p.nome),
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
        onPressed: () => abrirFormulario(),
      ),
    );
  }
}
