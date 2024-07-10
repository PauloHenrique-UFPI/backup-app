class User {
  int id;
  String email;
  String endereco;
  String cep;

  User({
    required this.id,
    required this.email,
    required this.endereco,
    required this.cep,
  });
  factory User.toMap(map) {
    return User(
      id: map['id'] ?? 1,
      email: map['email'] ?? "Não Informado",
      endereco: map['endereco'] ?? "Não Informado",
      cep: map['cep'] ?? "Não Informado",
    );
  }
}