class Borda {
  int id;
  String nome;
  double preco;

  Borda ({
    required this.id,
    required this.nome,
    required this.preco,
  });

  factory Borda.toMap(map){
    return Borda(
      id: map['id'] ?? 0, 
      nome: map['nome'] ?? 'Não Informado', 
      preco: map['preco'].toDouble() ?? 00.00,
      );
  }
}