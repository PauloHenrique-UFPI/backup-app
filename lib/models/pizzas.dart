class Pizza {
  int id;
  String img;
  String sabor;
  String ingredientes;
  Preco precos;
  String categoria;

  Pizza ({
    required this.id,
    required this.sabor,
    required this.ingredientes,
    required this.precos,
    required this.img,
    required this.categoria,
  });

  factory Pizza.fromMap(map){
    return Pizza(
      id: map['id'] ?? 0, 
      sabor: map['sabor'] ?? 'Não Informado', 
      ingredientes: map['ingredientes'] ?? 'Não Informado', 
      precos: Preco.fromMap(map['precos']),
      img: map['img'] ?? 'Não Informado',
      categoria: map['categoria'] ?? 'Não Informado'
      
      );
  }
  
}

class Preco {
  double p;
  double m;
  double g;
  double gg;

  Preco({
    required this.p,
    required this.m,
    required this.g,
    required this.gg,
  });

  factory Preco.fromMap(map) {
    return Preco(
      p: map['P']?.toDouble() ?? 0.00,
      m: map['M']?.toDouble() ?? 0.00,
      g: map['G']?.toDouble() ?? 0.00,
      gg: map['GG']?.toDouble() ?? 0.00,
    );
  }
}
