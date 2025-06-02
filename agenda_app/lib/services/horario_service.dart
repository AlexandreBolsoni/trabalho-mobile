import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/horario.dart';

class HorarioService {
  static const String baseUrl = 'http://127.0.0.1:8000/horarios/';
  static const String _token = '4e1765b9e1caaa4e4a30de71c1f1188c24e1e44c';

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token',
    };
  }

  static Future<List<Horario>> getHorarios() async {
    final response = await http.get(Uri.parse(baseUrl), headers: _headers());
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Horario.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar horarios');
    }
  }

 static Future<void> addHorario(Horario horario) async {
  final url = Uri.parse(baseUrl);
  final headers = _headers();
  final body = json.encode(horario.toJson());


  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  if (response.statusCode != 201) {
    throw Exception('Erro ao adicionar horario');
  }
}


  static Future<void> updateHorario(int id, Horario horario) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: _headers(),
      body: json.encode(horario.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar horario');
    }
  }

  static Future<void> deleteHorario(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$id/'),
      headers: _headers(),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir horario');
    }
  }
}
