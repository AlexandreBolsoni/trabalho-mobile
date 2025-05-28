import 'package:agendamento_app/models/paciente.dart';
import 'package:agendamento_app/models/profissional.dart';
import 'package:agendamento_app/models/sala.dart';
import 'package:agendamento_app/models/horario.dart';

class Agendamento {
  final int? id;
  final Paciente? paciente;
  final Profissional? profissional;
  final Sala? sala;
  final Horario? horario;
  final String? data;
  final String? hora;
  final String? status;

  Agendamento({
    this.id,
    required this.paciente,
    required this.profissional,
    required this.sala,
    required this.horario,
    this.data,
    this.hora,
    this.status,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    final pacienteJson = json['paciente'];
    final profissionalJson = json['profissional'];
    final salaJson = json['sala'];
    final horarioJson = json['horario'];

    return Agendamento(
      id: json['id'],
      paciente: pacienteJson is Map<String, dynamic>
          ? Paciente.fromJson(pacienteJson)
          : Paciente(
              id: pacienteJson,
              nome: 'Desconhecido',
              dataNascimento: 'data Desconhecida',
              telefone: 'Telefone Desconhecido',
              email: 'Email Desconhecido',
            ),
      profissional: profissionalJson is Map<String, dynamic>
          ? Profissional.fromJson(profissionalJson)
          : Profissional(
              id: profissionalJson,
              nome: 'Desconhecido',
              especialidade: 'Desconhecida',
              telefone: 'Desconhecido',
              email: 'Desconhecido',
            ),
      sala: salaJson is Map<String, dynamic>
          ? Sala.fromJson(salaJson)
          : Sala(
              id: salaJson,
              nomeSala: 'Desconhecida',
              andar: 0,
            ),
      horario: horarioJson is Map<String, dynamic>
          ? Horario.fromJson(horarioJson)
          : null, // Ou alguma construção padrão, se fizer sentido
      data: json['data'],
      hora: json['hora'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'paciente': paciente?.toJson(),
        'profissional': profissional?.toJson(),
        'sala': sala?.toJson(),
        'horario': horario?.toJson(),
        'data': data,
        'hora': hora,
        'status': status,
      };
}
