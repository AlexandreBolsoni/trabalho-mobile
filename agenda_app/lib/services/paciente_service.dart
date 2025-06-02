import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente.dart';

class PacienteService {
  static const String _baseUrl = 'http://127.0.0.1:8000/pacientes/';
  static const String _token = '4e1765b9e1caaa4e4a30de71c1f1188c24e1e44c';

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token',
    };
  }

  static Future<List<Paciente>> fetchPacientes() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers());

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Paciente.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar pacientes');
    }
  }

  static Future<void> addPaciente(Paciente paciente) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers(),
      body: jsonEncode(paciente.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao adicionar paciente');
    }
  }

  static Future<void> updatePaciente(int id, Paciente paciente) async {
    final response = await http.put(
      Uri.parse('$_baseUrl$id/'),
      headers: _headers(),
      body: jsonEncode(paciente.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar paciente');
    }
  }

  static Future<void> deletePaciente(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: _headers(),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar paciente');
    }
  }
}
