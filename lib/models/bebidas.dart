class Bebida {
  int id;
  String nome;
  String litros;
  double preco;
  bool promocao;
  String img;
  int qtd;

  Bebida ({
    required this.id,
    required this.nome,
    required this.litros,
    required this.preco,
    required this.promocao,
    required this.img,
    required this.qtd,
  });

  factory Bebida.toMap(map){
    return Bebida(
      id: map['id'] ?? 0, 
      nome: map['nome'] ?? 'Não Informado', 
      litros: map['litros'] ?? 'Não Informado', 
      preco: map['preco'] ?? 00.00, 
      promocao: map['promocao'] ?? false, 
      img: map['img'] ?? 'Não Informado',
      qtd: map['qtd'] ?? 0,
      );
  }
}