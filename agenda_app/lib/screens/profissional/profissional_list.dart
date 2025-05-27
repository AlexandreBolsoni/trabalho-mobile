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

  Future<void> excluirProfissional(int id) async {
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
                    onPressed: () => excluirProfissional(p.id),
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
