import 'package:veneza/models/user.dart';

class Pedido {
  int id;
  String status;
  double precoTotal;
  String formaPagamento;
  Endereco endereco;
  String local;
  String descricao;
  User cliente;
  List<Produto> produtos; 
  List<Bebida> bebidas;
  String dataHora;

  
  Pedido({
    required this.id,
    required this.status,
    required this.precoTotal,
    required this.formaPagamento,
    required this.endereco,
    required this.local,
    required this.descricao,
    required this.cliente,
    required this.produtos,
    required this.bebidas,
    required this.dataHora,
  });

  factory Pedido.toMap(map) {
    return Pedido(
      id: map['id'] ?? 0,
      dataHora: map['dataHora'] ?? "2000-00-00T00:00:00.000Z",
      status: map['status'] ?? 'não informado',
      precoTotal: map['precoTotal']?.toDouble() ?? 0.00,
      endereco: Endereco.toMap(map['endereco']),
      formaPagamento: map['FormaPagamento'] ?? 'não informado',
      local: map['local'],
      descricao: map['descricao'],
      cliente: User.toMap(map['usuario']),
      produtos: map['pizzas'] != null
          ? List<Produto>.from(map['pizzas'].map<Produto>((produto) => Produto.toMap(produto)))
          : [],
      bebidas: map['bebidas'] != null
          ? List<Bebida>.from(map['bebidas'].map<Bebida>((bebida) => Bebida.toMap(bebida)))
          : [Bebida(id: 0, nome: '0', preco: 0.00)]
    );
  }
}

class Produto {
  int id;
  double precoTotal;
  String tamanho;
  List<Sabores> sabores; 
  List<Adicional> adicionais;


  Produto({
    required this.id,
    required this.precoTotal,
    required this.tamanho,
    required this.sabores,
    required this.adicionais
  });

  factory Produto.toMap(map) {
    return Produto(
      id: map['id'] ?? 0,
      precoTotal: map['precoTotal']?.toDouble() ?? 0.00,
      tamanho: map['tamanho'],
      sabores: map['sabores'] != null
          ? List<Sabores>.from(map['sabores'].map<Sabores>((sabor) => Sabores.toMap(sabor)))
          : [],
      adicionais: map['ingredientesAdicionais'] != null
                ? List<Adicional>.from(map['ingredientesAdicionais'].map<Adicional>((adicional) => Adicional.toMap(adicional)))
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

class Adicional {
  int id;
  String nome;
  double preco;

  Adicional({
    required this.id,
    required this.nome,
    required this.preco,
  });

  factory Adicional.toMap(map) {
    return Adicional(
      id: map['id'] ?? 0,
      nome: map['nome'] ?? 'Não Informado',
      preco: map['preco']?.toDouble() ?? 0.00,
    );
  }
}

class Bebida {
  int id;
  String nome;
  double preco;

  Bebida({
    required this.id,
    required this.nome,
    required this.preco,
  });

  factory Bebida.toMap(map) {
    return Bebida(
      id: map['id'] ?? 0,
      nome: map['nome'] ?? 'Não Informado',
      preco: map['preco']?.toDouble() ?? 0.00,
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