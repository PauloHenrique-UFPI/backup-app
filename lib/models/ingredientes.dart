class Ingredientes {
  int id;
  String nome;
  double preco;

  Ingredientes ({
    required this.id,
    required this.nome,
    required this.preco,
  });

  factory Ingredientes.toMap(map){
    return Ingredientes(
      id: map['id'] ?? 0, 
      nome: map['nome'] ?? 'Não Informado', 
      preco: map['preco'].toDouble() ?? 00.00,
      );
  }
}