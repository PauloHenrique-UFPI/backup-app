import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/models/bebidas.dart';
import 'package:veneza/models/rest_client.dart';

class BebidaRepository {
  final RestClient _rest;
  BebidaRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Bebida>> buscarBebida(String a) async {
    final response = await _rest.get('/todas-bebida');
    return response["groups"].map<Bebida>(Bebida.toMap).toList();
  }

  Future<bool> update(Bebida valor, int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      final response = await _rest.put('/alterar-bebida/$id', {
        'nome': valor.nome,
        'litros': valor.litros,
        'preco': valor.preco,
        'qtd': valor.qtd,
      });
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
        'https://api-veneza.onrender.com/deletar-bebida/$id',
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