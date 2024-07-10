import 'package:veneza/models/pedidos.dart';
import 'package:veneza/models/rest_client.dart';

class PedidoRepository {
  final RestClient _rest;
  PedidoRepository({required RestClient restClient }) : _rest = restClient;

  Future<List<Pedido>> buscar(String a) async {
    final response = await _rest.get('/todos-pedidos');
    return response["groups"].map<Pedido>(Pedido.toMap).toList();
  }
}