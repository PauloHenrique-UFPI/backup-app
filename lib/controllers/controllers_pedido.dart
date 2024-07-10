import 'package:flutter/material.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/repositories/pedido_repository.dart';


class ControllerPedidos extends ChangeNotifier {
  final PedidoRepository _repository;
  String search = "";

  var _pedidos = <Pedido>[];
  bool loading = false;
  bool searching = false;

  void changeSearch(String key) {
    search = key;
    notifyListeners();
  }

  void changeSearching() {
    searching = !searching;
    if (!searching) search = "";
    notifyListeners();
  }

  ControllerPedidos({required PedidoRepository pedidoRepository})
      : _repository = pedidoRepository;

  List<Pedido> get pedido {
    return _pedidos
        .where((e) => e.descricao.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> buscarItens() async {
    try {
      loading = true;
      _pedidos = await _repository.buscar('Qualquer coisa ai');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}