import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sala.dart';

class SalaService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/salas/';

  Future<List<Sala>> getSalas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Sala.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar salas');
    }
  }

  Future<void> addSala(Sala sala) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sala.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar sala');
    }
  }

  Future<void> updateSala(int id, Sala sala) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sala.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar sala');
    }
  }

  Future<void> deleteSala(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir sala');
    }
  }
}
