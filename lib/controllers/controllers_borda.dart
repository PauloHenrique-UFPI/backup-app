import 'package:flutter/material.dart';
import 'package:veneza/models/borda.dart';
import 'package:veneza/repositories/borda_repository.dart';


class ControllerBorda extends ChangeNotifier {
  final BordaRepository _repository;
  String search = "";
  bool resultado = false;

  var _bordas = <Borda>[];
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

  ControllerBorda({required BordaRepository bordaRepository})
      : _repository = bordaRepository;

  List<Borda> get borda {
    return _bordas
        .where((e) => e.nome.toLowerCase().contains(search.toLowerCase()))
        .toList();  
  }

  Future<void> buscarBorda() async {
    try {
      loading = true;
      _bordas = await _repository.buscar('Qualquer coisa ai');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBorda(Borda valor, int id) async {
    try{
      loading = true;
      resultado = await _repository.update(valor, id);
    } finally {
      return resultado;
    }
  }

  Future<bool> addBorda(String nome, String preco) async {
    try{
      loading = true;
      resultado = await _repository.add(nome, preco);
    } finally {
      return resultado;
    }
  }
}