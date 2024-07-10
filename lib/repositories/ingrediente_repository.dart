import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/models/ingredientes.dart';
import 'package:veneza/models/rest_client.dart';

class IngredientesRepository {
  final RestClient _rest;
  IngredientesRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Ingredientes>> buscar(String a) async {
    final response = await _rest.get('/todos-ingrediente');
    return response["groups"].map<Ingredientes>(Ingredientes.toMap).toList();
  }

  Future<bool> update(Ingredientes valor, int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      final response = await _rest.put('/alterar-ingrediente/$id', {
        'nome': valor.nome,
        'preco': valor.preco
      });
      return true;
    } catch(error){
      return false;
    } 
  }

  Future<bool> add(String nome, String preco) async {
    double preP = double.tryParse(preco) ?? 0.00;
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');

    try {
      final response = await Dio().post(
        'https://api-veneza.onrender.com/criar-ingrediente', 
        data: {
            'nome': nome,
            'preco': preP
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
}