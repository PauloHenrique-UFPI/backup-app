import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/models/borda.dart';
import 'package:veneza/models/funcionarios.dart';
import 'package:veneza/models/rest_client.dart';

class FuncionarioRepository {
  final RestClient _rest;
  FuncionarioRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Funcionario>> buscar(String a) async {
    final response = await _rest.get('/todos');
    return response["groups"].map<Funcionario>(Funcionario.toMap).toList();
  }

  Future<Funcionario> buscarID(int id) async {
    final response = await _rest.get('/user/$id');
    return Funcionario.toMap(response);
  }

  Future<bool> update(Funcionario valor, int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      final response = await _rest.put('/alterar-borda/$id', {
        'email': valor.email,
        'telefone': valor.telefone,
        'dataNascimento': valor.dataNascimento,
        'cep': valor.cep,
        'endereco': valor.endereco,
        'tipo': valor.tipo

      });
      return true;
    } catch(error){
      return false;
    } 
  }

  Future<bool> add(Funcionario funcionario, String senha) async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      final response = await Dio().post(
        'https://api-veneza.onrender.com/criar', 
        data: {
            "email": funcionario.email, 
            "telefone": funcionario.telefone, 
            "dataNascimento": funcionario.dataNascimento, 
            "senha": senha, 
            "cep": funcionario.cep, 
            "endereco": funcionario.endereco,
            "tipo": funcionario.tipo
            },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),);
      return true;
    } catch(error){
      return false;
    } 
  }

  Future<bool> remover(int id) async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      final response = await Dio().delete(
        'https://api-veneza.onrender.com/deletar-usuario/$id',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),);
      print(response);
      return true;
    } catch(error){
      return false;
    } 
  }
}