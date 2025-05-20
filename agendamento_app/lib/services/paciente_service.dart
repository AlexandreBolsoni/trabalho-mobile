import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente.dart';

class PacienteService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/pacientes/';

  static Future<List<Paciente>> fetchPacientes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonData.map((p) => Paciente.fromJson(p)).toList();
    } else {
      throw Exception('Erro ao carregar pacientes');
    }
  }

  static Future<void> addPaciente(Paciente paciente) async {
    await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(paciente.toJson()));
  }

  static Future<void> updatePaciente(int id, Paciente paciente) async {
    await http.put(Uri.parse('$baseUrl$id/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(paciente.toJson()));
  }

  static Future<void> deletePaciente(int id) async {
    await http.delete(Uri.parse('$baseUrl$id/'));
  }
}
