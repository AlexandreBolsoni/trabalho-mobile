class Agendamento {
  final int id;
  final int pacienteId;
  final int profissionalId;
  final int salaId;
  final String data;
  final String hora;
  final String status;

  Agendamento({
    required this.id,
    required this.pacienteId,
    required this.profissionalId,
    required this.salaId,
    required this.data,
    required this.hora,
    required this.status,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      pacienteId: json['id_paciente'],
      profissionalId: json['id_profissional'],
      salaId: json['sala_id'],
      data: json['data'],
      hora: json['hora'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_paciente': pacienteId,
      'id_profissional': profissionalId,
      'sala_id': salaId,
      'data': data,
      'hora': hora,
      'status': status,
    };
  }
}
