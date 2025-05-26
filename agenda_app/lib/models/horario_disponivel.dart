import 'package:agendamento_app/models/profissional.dart';

class HorarioDisponivel {
  Profissional? profissional;
  String? data;
  String? horaInicio;
  String? horaFim;

  HorarioDisponivel({
    required this.profissional,
    this.data,
    this.horaInicio,
    this.horaFim,
  });

  factory HorarioDisponivel.fromJson(Map<String, dynamic> json) {
    return HorarioDisponivel(
      profissional: Profissional.fromJson(json['profissional']),
      data: json['data'],
      horaInicio: json['hora_inicio'], // <- CORRETO
      horaFim: json['hora_fim'],       // <- CORRETO
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profissional': profissional?.toJson(),
      'data': data,
      'hora_inicio': horaInicio, 
      'hora_fim': horaFim,     
    };
  }
}
