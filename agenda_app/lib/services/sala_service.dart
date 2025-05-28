import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sala.dart';

class SalaService {
  static const String _baseUrl = 'http://127.0.0.1:8000/salas/';
  static const String _token = '4e1765b9e1caaa4e4a30de71c1f1188c24e1e44c';

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token',
    };
  }

  static Future<List<Sala>> fetchSalas() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers());
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Sala.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar salas');
    }
  }

  static Future<void> addSala(Sala sala) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers(),
      body: json.encode(sala.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao adicionar sala');
    }
  }

  static Future<void> updateSala(int id, Sala sala) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$id/'),
      headers: _headers(),
      body: json.encode(sala.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar sala');
    }
  }

  static Future<void> deleteSala(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: _headers(),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir sala');
    }
  }
}
