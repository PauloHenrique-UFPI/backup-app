import 'package:flutter/material.dart';
import 'package:veneza/models/funcionarios.dart';
import 'package:veneza/repositories/funcionario_repository.dart';


class ControllerFuncionario extends ChangeNotifier {
  final FuncionarioRepository _repository;
  String search = "";
  bool resultado = false;

  var _funcionarios = <Funcionario>[];
  var fun = Funcionario;
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

  ControllerFuncionario({required FuncionarioRepository funcionarioRepository})
      : _repository = funcionarioRepository;

  List<Funcionario> get funcionario {
    return _funcionarios
        .where((e) => e.email.toLowerCase().contains(search.toLowerCase()))
        .toList();  
  }

  Future<void> buscarFuncionario() async {
    try {
      loading = true;
      _funcionarios = await _repository.buscar('Qualquer coisa ai');
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  Future<bool> updateFuncionario(Funcionario valor, int id) async {
    try{
      loading = true;
      resultado = await _repository.update(valor, id);
    } finally {
      return resultado;
    }
  }

  Future<bool> addFuncionario(Funcionario valor, String senha) async {
    try{
      loading = true;
      resultado = await _repository.add(valor, senha);
    } finally {
      return resultado;
    }
  }

  Future<bool> deletarFuncionario(int id) async {
    try{
       loading = true;
    resultado = await _repository.remover(id);
    } finally {
      return resultado;
   }
   
  } 
}