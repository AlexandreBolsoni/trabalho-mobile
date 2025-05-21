import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/agendamento.dart';

class AgendamentoService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/agendamentos/';

  static Future<List<Agendamento>> getAgendamentos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Agendamento.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar agendamentos');
    }
  }

 

  static Future<void> createAgendamento(Agendamento agendamento) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(agendamento.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar agendamento');
    }
  }
  

  static Future<void> updateAgendamento(int id, Agendamento agendamento) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(agendamento.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar agendamento');
    }
  }

  static Future<void> deleteAgendamento(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir agendamento');
    }
  }
}
