class Sala {
  final int id;
  final String nomeSala;
  final int andar;

  Sala({
    required this.id,
    required this.nomeSala,
    required this.andar,
  });

  factory Sala.fromJson(Map<String, dynamic> json) {
  return Sala(
    id: json['id'],
    nomeSala: json['nome_sala'] ?? '',  // <-- aqui evita o erro
    andar: json['andar'] ?? 0,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'nome_sala': nomeSala,
      'andar': andar,
    };
  }
}
