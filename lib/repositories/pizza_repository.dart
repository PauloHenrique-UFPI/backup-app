import 'package:veneza/models/pizzas.dart';
import 'package:veneza/models/rest_client.dart';

class PizzaRepository {
  final RestClient _rest;
  PizzaRepository({required RestClient restClient}) : _rest = restClient;

  Future<List<Pizza>> buscarPizza(String a) async {
    final response = await _rest.get('/todas-pizza');
    return response["groups"].map<Pizza>(Pizza.fromMap).toList();
  }
}