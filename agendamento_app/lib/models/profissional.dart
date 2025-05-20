class Profissional {
  final int id;
  final String nome;
  final String especialidade;
  final String telefone;
  final String email;

  Profissional({
    required this.id,
    required this.nome,
    required this.especialidade,
    required this.telefone,
    required this.email,
  });

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      id: json['id'],
      nome: json['nome'],
      especialidade: json['especialidade'],
      telefone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'especialidade': especialidade,
      'telefone': telefone,
      'email': email,
    };
  }
}
