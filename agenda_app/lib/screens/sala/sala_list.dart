import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sala_form.dart';

class SalaList extends StatefulWidget {
  const SalaList({super.key});

  @override
  State<SalaList> createState() => _SalaListState();
}

class _SalaListState extends State<SalaList> {
  List salas = [];

  @override
  void initState() {
    super.initState();
    carregarSalas();
  }

  Future<void> carregarSalas() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/salas/'));

    if (response.statusCode == 200) {
      setState(() {
        salas = jsonDecode(utf8.decode(response.bodyBytes));
      });
    }
  }

  Future<void> excluirSala(int id) async {
    final response =
        await http.delete(Uri.parse('http://127.0.0.1:8000/api/salas/$id/'));

    if (response.statusCode == 204) {
      carregarSalas();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir sala')),
      );
    }
  }

  void abrirFormulario([Map? sala]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalaForm(sala: sala),
      ),
    );

    if (resultado == true) {
      carregarSalas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => abrirFormulario(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: salas.length,
        itemBuilder: (context, index) {
          final s = salas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(s['nome_sala'] ?? ''),
              subtitle: Text('Andar: ${s['andar'] ?? 'N/A'}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => abrirFormulario(s),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => excluirSala(s['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
