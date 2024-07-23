import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/models/pizzas.dart';
import 'package:veneza/models/rest_client.dart';

class PizzaRepository {
  final RestClient _rest;
  PizzaRepository({required RestClient restClient}) : _rest = restClient;

  Future<List<Pizza>> buscarPizza(String a) async {
    final response = await _rest.get('/todas-pizza');
    return response["groups"].map<Pizza>(Pizza.fromMap).toList();
  }

  Future<bool> update(Pizza valor, int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
      
    String? token = sharedPreferences.getString('token');

    Map<String, dynamic> precos = {
      'P': valor.precos.p,
      'M': valor.precos.m,
      'G': valor.precos.g,
      'GG': valor.precos.gg,
    };

     // Convertendo o mapa de preços para JSON
    String precosJson = jsonEncode(precos);
    print('Preços JSON: $precosJson');

    FormData formData = FormData.fromMap({
      "sabor": valor.sabor,
      "ingredientes": valor.ingredientes,
      "precos": precosJson,
      "categoria": valor.categoria
    });
    try {
      final response = await Dio().put(
        'https://api-veneza.onrender.com/alterar-pizza/$id',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return true;
    } catch(error){
      return false;
    } 
  }
}