import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:http/http.dart' as http;
import 'package:veneza/models/rest_client.dart';

class PedidoRepository {
  final RestClient _rest;
  PedidoRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Pedido>> buscar(String a) async {
    final response = await _rest.get('/todos-pedidos');
    return response["groups"].map<Pedido>(Pedido.toMap).toList();
  }

  Future<List<Pedido>> buscarID(String a, String id) async {
    final response = await _rest.get('/usuario-pedido/$id');
    return response["groups"].map<Pedido>(Pedido.toMap).toList();
  }

  Future<bool> cancelar(int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      final response = await Dio().put('https://api-veneza.onrender.com/cancelar-pedido/$id',options: Options(
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

  Future<bool> aceitar(int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      final response = await Dio().put('https://api-veneza.onrender.com/aceitar-pedido/$id',options: Options(
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

  Future<bool> entrega(int id) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('token');
    try {
      final response = await Dio().put('https://api-veneza.onrender.com/entregar-pedido/$id',options: Options(
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


  Future<bool> downloadAndSavePDF(String url, String fileName) async {
    final httpCliente = GetIt.I.get<RestClient>();
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    try {
      // Faz a requisição para a API
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      },);

      if (response.statusCode == 200) {
        // Obtém o diretório para salvar o arquivo
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';

        // Salva o arquivo no sistema de arquivos
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('PDF salvo em: $filePath');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}