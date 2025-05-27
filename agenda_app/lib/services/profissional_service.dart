import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profissional.dart';

class ProfissionalService {
  static const String baseUrl = 'http://127.0.0.1:8000/profissionais/';
  
  // Aqui  token de autenticação.
  static String token = '4e1765b9e1caaa4e4a30de71c1f1188c24e1e44c';

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      };

  static Future<List<Profissional>> getProfissionais() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Profissional.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar profissionais: ${response.statusCode}');
    }
  }

  static Future<void> addProfissional(Profissional profissional) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(profissional.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar profissional: ${response.statusCode}');
    }
  }

  static Future<void> updateProfissional(int id, Profissional profissional) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: headers,
      body: json.encode(profissional.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar profissional: ${response.statusCode}');
    }
  }

  static Future<void> deleteProfissional(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$id/'),
      headers: headers,
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir profissional: ${response.statusCode}');
    }
  }
}
