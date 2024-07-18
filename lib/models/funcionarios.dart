class Funcionario {
  int id;
  String email;
  String telefone;
  String dataNascimento;
  String cep;
  String endereco;
  String tipo;

  Funcionario({
    required this.id,
    required this.email,
    required this.telefone,
    required this.dataNascimento,
    required this.cep,
    required this.endereco,
    required this.tipo,
  });
  factory Funcionario.toMap(map) {
    return Funcionario(
      id: map['id'] ?? 1,
      email: map['email'] ?? "Não Informado",
      telefone: map['telefone'] ?? "(00)0 0000-0000",
      dataNascimento: map['dataNascimento'] ?? "2000-00-00T00:00:00.000Z",
      endereco: map['endereco'] ?? "Não Informado",
      cep: map['cep'] ?? "Não Informado",
      tipo: map['tipo'] ?? "",
    );
  }
}