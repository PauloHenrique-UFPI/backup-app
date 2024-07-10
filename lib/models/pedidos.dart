import 'package:veneza/models/user.dart';

class Pedido {
  int id;
  String status;
  double precoTotal;
  String local;
  String descricao;
  User cliente;
  List<Produto> produtos; 

  
  Pedido({
    required this.id,
    required this.status,
    required this.precoTotal,
    required this.local,
    required this.descricao,
    required this.cliente,
    required this.produtos,
  });

  factory Pedido.toMap(map) {
    return Pedido(
      id: map['id'] ?? 0,
      status: map['status'] ?? 'não informado',
      precoTotal: map['precoTotal']?.toDouble() ?? 0.00,
      local: map['local'],
      descricao: map['descricao'],
      cliente: User.toMap(map['usuario']),
      produtos: map['pizzas'] != null
          ? List<Produto>.from(map['pizzas'].map<Produto>((produto) => Produto.toMap(produto)))
          : [],
    );
  }
}

class Produto {
  int id;
  double precoTotal;
  String tamanho;
  List<Sabores> sabores; 


  Produto({
    required this.id,
    required this.precoTotal,
    required this.tamanho,
    required this.sabores,
  });

  factory Produto.toMap(map) {
    return Produto(
      id: map['id'] ?? 0,
      precoTotal: map['precoTotal']?.toDouble() ?? 0.00,
      tamanho: map['tamanho'],
      sabores: map['sabores'] != null
          ? List<Sabores>.from(map['sabores'].map<Sabores>((sabor) => Sabores.toMap(sabor)))
          : [],
    );
  }
}

class Sabores {
  int id;
  String sabor;
  String categoria;

   Sabores({
    required this.id,
    required this.sabor,
    required this.categoria,
  });

  factory Sabores.toMap(map) {
    return Sabores(
      id: map['id'] ?? 0,
      sabor: map['sabor'] ?? 'Não Informado',
      categoria: map['categoria'] ?? 'Não Informado',
    );
  }
}