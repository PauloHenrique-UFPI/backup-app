import 'package:flutter/material.dart';
import 'package:veneza/models/pizzas.dart';
import 'package:veneza/repositories/pizza_repository.dart';

class ControllerPizzas extends ChangeNotifier {
  final PizzaRepository _repository;
  String search = "";

  var _pizzas = <Pizza>[];
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

  ControllerPizzas({required PizzaRepository pizzaRepository})
      : _repository = pizzaRepository;

  List<Pizza> get pizza {
    return _pizzas
        .where((e) => e.sabor.toLowerCase().contains(search.toLowerCase()))
        .toList();  
  }

  Future<void> buscarPizza() async {
    try {
      loading = true;
      _pizzas = await _repository.buscarPizza('Qualquer coisa ai');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<List<Pizza>> listarPizza() async {
    try {
      loading = true;
      _pizzas = await _repository.buscarPizza('Qualquer coisa ai');
    } finally {
      loading = false;
      return _pizzas;
    }
  }
}