import 'package:flutter/material.dart';
import 'package:veneza/models/bebidas.dart';
import 'package:veneza/repositories/bebida_repository.dart';

class ControllerBebidas extends ChangeNotifier {
  final BebidaRepository _repository;
  String search = "";

  var _bebidas = <Bebida>[];
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

  ControllerBebidas({required BebidaRepository bebidaRepository})
      : _repository = bebidaRepository;

  List<Bebida> get bebida {
    return _bebidas
        .where((e) => e.nome.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Future<void> buscarBebida() async {
    try {
      loading = true;
      _bebidas = await _repository.buscarBebida('Qualquer coisa ai');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}