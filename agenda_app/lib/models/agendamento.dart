import 'package:agendamento_app/models/paciente.dart';
import 'package:agendamento_app/models/profissional.dart';
import 'package:agendamento_app/models/sala.dart';
class Agendamento {
  final int? id;
  final Paciente? paciente;
  final Profissional? profissional;
  final Sala? sala;
  final String data;
  final String hora;
  final String status;

  Agendamento({
    this.id,
    this.paciente,
    this.profissional,
    this.sala,
    required this.data,
    required this.hora,
    required this.status,
  });

factory Agendamento.fromJson(Map<String, dynamic> json) {
  return Agendamento(
    id: json['id'],
    paciente: Paciente(id: json['paciente'], nome: 'Desconhecido', dataNascimento: '1900-01-01', telefone: 'Desconhecido', email: 'Desconhecido'),
    profissional: Profissional(id: json['profissional'], nome: 'Desconhecido', especialidade: 'Desconhecida', telefone: 'Desconhecido', email: 'Desconhecido'),
    sala: Sala(id: json['sala'], nomeSala: 'Desconhecida', andar: 0),
    data: json['data'],
    hora: json['hora'],
    status: json['status'],
  );
}



  Map<String, dynamic> toJson() {
    return {
      'paciente': paciente?.id,
      'profissional': profissional?.id,
      'sala': sala?.id,
      'data': data,
      'hora': hora,
      'status': status,
    };
  }
}
