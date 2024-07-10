import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/models/borda.dart';
import 'package:veneza/models/rest_client.dart';

class BordaRepository {
  final RestClient _rest;
  BordaRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Borda>> buscar(String a) async {
    final response = await _rest.get('/todas-borda');
    return response["groups"].map<Borda>(Borda.toMap).toList();
  }

  Future<bool> update(Borda valor, int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      final response = await _rest.put('/alterar-borda/$id', {
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
        'https://api-veneza.onrender.com/criar-borda', 
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