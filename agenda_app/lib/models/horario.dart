import 'package:agendamento_app/models/profissional.dart';

class Horario {
  Profissional? profissional;
  String? data;
  String? horaInicio;
  String? horaFim;

  Horario({
    required this.profissional,
    this.data,
    this.horaInicio,
    this.horaFim,
  });

factory Horario.fromJson(Map<String, dynamic> json) {
  final profissionalJson = json['profissional'];

  return Horario(
    profissional: profissionalJson is Map<String, dynamic>
        ? Profissional.fromJson(profissionalJson)
        :  Profissional(
      id: profissionalJson, 
      nome: 'Desconhecido', 
      especialidade: 'Desconhecida', 
      telefone: 'Desconhecido',
      email: 'Desconhecido',

    ),
    data: json['data'],
    horaInicio: json['hora_inicio'],
    horaFim: json['hora_fim'],
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
