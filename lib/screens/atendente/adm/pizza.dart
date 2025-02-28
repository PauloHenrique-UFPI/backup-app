import 'dart:math';

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
          appBar:AppBar(
              elevation: 1,
              backgroundColor: Colors.orange,
              title: controller.searching 
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        autofocus: true,
                        onChanged: controller.changeSearch,
                        decoration: const InputDecoration(labelText: 'Sabor: '),
                      ),
                    )
                  : const Center(
                      child: Text('Lista de Pizzas'), 
                    ), 
              actions: [
                IconButton(
                  color: Colors.black,
                  onPressed: controller.changeSearching,
                  icon: controller.searching
                      ? const Icon(Icons.close)
                      : const Icon(Icons.search_sharp),
                ),
              ],
            ),
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
          onTap: () => _showEditDialog(context, pizzas[index]),
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


void _showEditDialog(BuildContext context, Pizza pizza) {
    final TextEditingController saborController = TextEditingController(text: pizza.sabor);
    final TextEditingController ingredientesController = TextEditingController(text: pizza.ingredientes);
    final TextEditingController categoriaController = TextEditingController(text: pizza.categoria);
    final TextEditingController pController = TextEditingController(text: pizza.precos.p.toString());
    final TextEditingController mController = TextEditingController(text: pizza.precos.m.toString());
    final TextEditingController gController = TextEditingController(text: pizza.precos.g.toString());
    final TextEditingController ggController = TextEditingController(text: pizza.precos.gg.toString());
    final controlador = ControllerPizzas(
    pizzaRepository: PizzaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text(
                'Editar Pizza',
                textAlign: TextAlign.center,
              ),
                        content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(pizza.img),
                        fit: BoxFit.cover,
                        width: 150,
                        height: 100,
                      ),
                    ),
                SizedBox(height: 10), 
                TextField(
                  controller: saborController,
                  decoration: const InputDecoration(labelText: 'Sabor'),
                ),
                TextField(
                  controller: ingredientesController,
                  decoration: const InputDecoration(labelText: 'Ingredientes'),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: pController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Preço P*",
                        ),
                      ),
                    ),
                      
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: 200, // Define a largura desejada
                    child: TextFormField(
                      maxLines: null,
                      controller: mController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Preço M*",
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: 200, // Define a largura desejada
                    child: TextFormField(
                      maxLines: null,
                      controller: gController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Preço G*",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: ggController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Preço GG*",
                        ),
                      ),
                    ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Salvar'),
                onPressed: () {
                  pizza.sabor = saborController.text;
                  pizza.ingredientes = ingredientesController.text;
                  pizza.precos.p = double.parse(pController.text);
                  pizza.precos.m = double.parse(mController.text);
                  pizza.precos.g = double.parse(gController.text);
                  pizza.precos.gg = double.parse(ggController.text);

                  try {
                    controlador.updatePizza(pizza, pizza.id);
                    Navigator.pushNamed(context, '/pizza'); 
                  } catch (e) {
                    print('Erro ao atualizar pizza: $e');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }