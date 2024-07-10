import 'package:veneza/models/bebidas.dart';
import 'package:veneza/models/rest_client.dart';

class BebidaRepository {
  final RestClient _rest;
  BebidaRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Bebida>> buscarBebida(String a) async {
    final response = await _rest.get('/todas-bebida');
    return response["groups"].map<Bebida>(Bebida.toMap).toList();
  }
}