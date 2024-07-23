class User {
  int id;
  String email;
  List<Endereco> enderecos;
  String cep;

  User({
    required this.id,
    required this.email,
    required this.enderecos,
    required this.cep,
  });
  factory User.toMap(map) {
    return User(
      id: map['id'] ?? 1,
      email: map['email'] ?? "Não Informado",
      enderecos: map['enderecos'] != null
          ? List<Endereco>.from(map['enderecos'].map<Endereco>((endereco) => Endereco.toMap(endereco)))
          : [],
      cep: map['cep'] ?? "Não Informado",
    );
  }
}

class Endereco {
  int id;
  String cep;
  String endereco;
  String referencia;

  Endereco({
    required this.id,
    required this.cep,
    required this.endereco,
    required this.referencia
  });

  factory Endereco.toMap(map) {
    return Endereco(
      id: map['id'] ?? 0,
      cep: map['cep'] ?? "Não Informado",
      endereco: map['endereco'] ?? "Não Informado",
      referencia: map['referencia'] ?? "Não Informado",
    );
  }
}
