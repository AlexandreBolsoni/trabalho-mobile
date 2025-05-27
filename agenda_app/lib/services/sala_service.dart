import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sala.dart';

class SalaService {
  static const String baseUrl = 'http://127.0.0.1:8000/salas/';

  // Token armazenado aqui, pode ser setado externamente
  static String? _token;

  // Método para configurar o token (chame antes de usar os métodos que fazem requisição)
  static void setToken(String token) {
    _token =  '4e1765b9e1caaa4e4a30de71c1f1188c24e1e44c';
  }

  // Cabeçalhos para a requisição, incluindo o token se presente
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Token $_token',
    };
  }

  static Future<List<Sala>> getSalas() async {
    final response = await http.get(Uri.parse(baseUrl), headers: _getHeaders());
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Sala.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar salas');
    }
  }

  static Future<void> addSala(Sala sala) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _getHeaders(),
      body: json.encode(sala.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar sala');
    }
  }

  static Future<void> updateSala(int id, Sala sala) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: _getHeaders(),
      body: json.encode(sala.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar sala');
    }
  }

  static Future<void> deleteSala(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$id/'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir sala');
    }
  }
}
