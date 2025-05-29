import 'paciente.dart';
import 'profissional.dart';
import 'sala.dart';

class Agendamento {
  final int? id;
  final Profissional? profissional;
  final Paciente? paciente;
  final Sala? sala;
  final String? data;  // yyyy-MM-dd
  final String? hora;  // HH:mm:ss
  final String? status;

  // Para enviar IDs
  final int? profissionalId;
  final int? pacienteId;
  final int? salaId;

  Agendamento({
    this.id,
    this.profissional,
    this.paciente,
    this.sala,
    this.data,
    this.hora,
    this.status,
    this.profissionalId,
    this.pacienteId,
    this.salaId,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      profissional: json['profissional'] != null
          ? Profissional.fromJson(json['profissional'])
          : null,
      paciente: json['paciente'] != null
          ? Paciente.fromJson(json['paciente'])
          : null,
      sala: json['sala'] != null ? Sala.fromJson(json['sala']) : null,
      data: json['data'],
      hora: json['hora'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profissional_id': profissionalId ?? profissional?.id,
      'paciente_id': pacienteId ?? paciente?.id,
      'sala_id': salaId ?? sala?.id,
      'data': data,
      'hora': hora,
      'status': status,
    };
  }
}
