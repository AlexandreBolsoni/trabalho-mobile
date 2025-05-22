import 'package:agendamento_app/models/profissional.dart';
import 'package:flutter/foundation.dart';

class HorarioDisponivel {
  Profissional? profissional;
  String? data;
  String? horaInicio;
  String? horaFim;

  HorarioDisponivel({
    required this.profissional,
   this.data, this.horaInicio, 
   this.horaFim
   });
   factory HorarioDisponivel.fromJson(Map<String, dynamic> json) {
    return HorarioDisponivel(
      profissional: Profissional.fromJson(json['profissional']),
      data: json['data'],
      horaInicio: json['horaInicio'],
      horaFim: json['horaFim'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'profissional': profissional?.toJson(),
      'data': data,
      'horaInicio': horaInicio,
      'horaFim': horaFim,
    };
  }

}
