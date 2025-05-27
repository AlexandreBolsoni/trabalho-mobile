import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/horario_disponivel.dart';

class HorarioService {
  static const String baseUrl = 'http://127.0.0.1:8000/horarios/';

  static Future<List<HorarioDisponivel>> fetchHorarios() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
  List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => HorarioDisponivel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar horarios');
    }
  }

 static Future<void> addHorario(HorarioDisponivel horario) async {
  await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(horario.toJson()),
  ); 
 } 

 static Future<void> updateHorario(int id, HorarioDisponivel horario) async {
  final response = await http.put(
    Uri.parse('$baseUrl$id/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(horario.toJson()),
  );
  if (response.statusCode != 200) {
    throw Exception('Erro ao atualizar horario');
  }
}
static Future<void> deleteHorario(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl$id/'));
  if (response.statusCode != 204) {
    throw Exception('Erro ao excluir horario');
  }
}
}