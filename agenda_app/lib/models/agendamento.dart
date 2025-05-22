import 'package:agendamento_app/models/paciente.dart';
import 'package:agendamento_app/models/profissional.dart';
import 'package:agendamento_app/models/sala.dart';

class Agendamento {
  final int id;
  Paciente? paciente;
  Profissional? profissional;
  Sala? sala;
  final String data;
  final String hora;
  final String status;

  Agendamento({
    required this.id,
    required Paciente? paciente,
    required Profissional? profissional,
    required Sala? sala,
    required this.data,
    required this.hora,
    required this.status,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      paciente: Paciente.fromJson(json['paciente']),
      profissional: Profissional.fromJson(json['profissional']),
      sala: Sala.fromJson(json['sala']),
      data: json['data'],
      hora: json['hora'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ' paciente': paciente?.toJson(),
      'profissional': profissional?.toJson(),
      'sala': sala?.toJson(),
      'data': data,
      'hora': hora,
      'status': status,
    };
  }
}
