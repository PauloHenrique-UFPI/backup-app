import 'package:flutter/material.dart';
import 'package:veneza/models/borda.dart';
import 'package:veneza/models/ingredientes.dart';
import 'package:veneza/repositories/borda_repository.dart';
import 'package:veneza/repositories/ingrediente_repository.dart';


class ControllerIngrediente extends ChangeNotifier {
  final IngredientesRepository _repository;
  String search = "";
  bool resultado = false;

  var _ingredientes = <Ingredientes>[];
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

  ControllerIngrediente({required IngredientesRepository ingredientesRepository})
      : _repository = ingredientesRepository;

  List<Ingredientes> get ingredientes {
    return _ingredientes
        .where((e) => e.nome.toLowerCase().contains(search.toLowerCase()))
        .toList();  
  }

  Future<void> buscarIngredientes() async {
    try {
      loading = true;
      _ingredientes = await _repository.buscar('Qualquer coisa ai');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateIngrediente(Ingredientes valor, int id) async {
    try{
      loading = true;
      resultado = await _repository.update(valor, id);
    } finally {
      return resultado;
    }
  }

  Future<bool> addIngrediente(String nome, String preco) async {
    try{
      loading = true;
      resultado = await _repository.add(nome, preco);
    } finally {
      return resultado;
    }
  }
}