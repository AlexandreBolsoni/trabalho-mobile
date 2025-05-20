import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profissional.dart';

class ProfissionalService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/profissionais/';

  Future<List<Profissional>> getProfissionais() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Profissional.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar profissionais');
    }
  }

  Future<void> addProfissional(Profissional profissional) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profissional.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar profissional');
    }
  }

  Future<void> updateProfissional(int id, Profissional profissional) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profissional.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar profissional');
    }
  }

  Future<void> deleteProfissional(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir profissional');
    }
  }
}
