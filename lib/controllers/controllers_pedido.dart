import 'package:flutter/material.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/repositories/pedido_repository.dart';


class ControllerPedidos extends ChangeNotifier {
  final PedidoRepository _repository;
  String search = "";

  var _pedidos = <Pedido>[];
  bool loading = false;
  bool searching = false;
  bool resultado = false;

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
        .where((e) => e.status.toLowerCase().contains(search.toLowerCase()))
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

  Future<void> buscarPorId(String id) async {
    try {
      loading = true;
      _pedidos = await _repository.buscarID('Qualquer coisa ai', id);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelarPedido(int id) async {
    try{
      loading = true;
      resultado = await _repository.cancelar(id);
    } finally {
      return resultado;
    }
  }

  Future<bool> aceitarPedido(int id) async {
    try{
      loading = true;
      resultado = await _repository.aceitar(id);
    } finally {
      return resultado;
    }
  }

  Future<bool> entregaPedido(int id) async {
    try{
      loading = true;
      resultado = await _repository.entrega(id);
    } finally {
      return resultado;
    }
  }

  Future<bool> imprimirPedido(int id) async {
    try{
      loading = true;
      resultado = await _repository.downloadAndSavePDF("https://api-veneza.onrender.com/imprimir-pedido/$id","pedido.pdf");
    } finally {
      return resultado;
    }
  }
}