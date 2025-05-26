import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profissional_form.dart';

class ProfissionalList extends StatefulWidget {
  const ProfissionalList({super.key});

  @override
  State<ProfissionalList> createState() => _ProfissionalListState();
}

class _ProfissionalListState extends State<ProfissionalList> {
  List profissionais = [];

  @override
  void initState() {
    super.initState();
    carregarProfissionais();
  }

  Future<void> carregarProfissionais() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/profissionais/'));

    if (response.statusCode == 200) {
      setState(() {
        profissionais = jsonDecode(utf8.decode(response.bodyBytes));
      });
    }
  }

  Future<void> excluirProfissional(int id) async {
    final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/profissionais/$id/'));

    if (response.statusCode == 204) {
      carregarProfissionais();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir profissional')),
      );
    }
  }

  void abrirFormulario([Map? profissional]) async {
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
        actions: [
        
        ],
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
              title: Text(p['nome']),
              subtitle: Text('${p['especialidade']} | ${p['email']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => abrirFormulario(p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => excluirProfissional(p['id_profissional']),
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
