import 'package:flutter/material.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_pizza.dart';
import 'package:veneza/models/pizzas.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/repositories/pizza_repository.dart';

class PizzaPage extends StatefulWidget {
  const PizzaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PizzaPageState();
  }
}

class PizzaPageState extends State<PizzaPage> {
  final controller = ControllerPizzas(
    pizzaRepository: PizzaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

  @override
  void initState() {
    controller.buscarPizza();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBarAtendente(),
          drawer: DrawerAtendente(),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: _Body(pizzas: controller.pizza),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () => { Navigator.pushNamed(context, "/addPizza") },
            child: const Icon(Icons.add),
          ),
        );
      },
    );

  }
}

class _Body extends StatelessWidget {
  final List<Pizza> pizzas;
  const _Body({required this.pizzas});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pizzas.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => {
            // Navigator.pushNamed(context, NoticiaCompletaViewRoute,
            //     arguments: noticias[index]),
          },
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Conteúdo à esquerda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Título
                        Text(
                          pizzas[index].sabor,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 146, 107, 49),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pizzas[index].ingredientes,
                          textAlign: TextAlign.left,
                        ),
                        
                        const SizedBox(height: 5),
                        const Divider(color: Colors.black),
                         Text(
                          'Preço: R\$ ${pizzas[index].precos.g}',
                        ),
                        const SizedBox(height: 5), 
                        // Text(
                        //   'R\$ ${pizzas[index].preco.toStringAsFixed(2)}',
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(pizzas[index].img),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}