class Sala {
  final int? id;
  final String nomeSala;
  final int andar;

  Sala({
    this.id,
    required this.nomeSala,
    required this.andar,
  });

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      id: json['id'],
      nomeSala: json['nome_sala'],
      andar: json['andar'],
    );
  }

  get nome => null;

  Map<String, dynamic> toJson() {
    return {
      'nome_sala': nomeSala,
      'andar': andar,
    };
  }
}
