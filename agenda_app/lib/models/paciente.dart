class Paciente {
  final int? id; // id opcional
  final String nome;
  final String dataNascimento;
  final String telefone;
  final String email;

  Paciente({
    this.id, // Removido o required
    required this.nome,
    required this.dataNascimento,
    required this.telefone,
    required this.email,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'],
      nome: json['nome'],
      dataNascimento: json['data_nascimento'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'data_nascimento': dataNascimento,
      'telefone': telefone,
      'email': email,
    };
  }
}
