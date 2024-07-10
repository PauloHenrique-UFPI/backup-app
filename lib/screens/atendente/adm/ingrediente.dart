import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_ingrediente.dart';
import 'package:veneza/models/ingredientes.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:veneza/repositories/ingrediente_repository.dart';

class IngredientePage extends StatefulWidget {
  const IngredientePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IngredientePageState();
  }
}

class IngredientePageState extends State<IngredientePage> {
  final controller = ControllerIngrediente(
    ingredientesRepository: IngredientesRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

  @override
  void initState() {
    controller.buscarIngredientes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
            child: _Body(ingrediente: controller.ingredientes, controller: controller),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () {
              _showAddDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController precoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Adicional'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
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
              child: const Text('Adicionar'),
              onPressed: () {
                try {
                  controller.addIngrediente(nomeController.text, precoController.text);
                  Navigator.pushNamed(context, '/ingrediente'); 
                } catch (e) {
                  print('Erro ao adicionar ingrediente: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final List<Ingredientes> ingrediente;
  final ControllerIngrediente controller;

  const _Body({required this.ingrediente, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de itens por linha
        crossAxisSpacing: 10, // Espaçamento horizontal entre os itens
        mainAxisSpacing: 10, // Espaçamento vertical entre os itens
        childAspectRatio: 3 / 2, // Proporção da largura para a altura dos itens
      ),
      itemCount: ingrediente.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showEditDialog(context, ingrediente[index]),
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(6.0),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ingrediente[index].nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 29, 118, 233),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'R\$ ${ingrediente[index].preco.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Ingredientes ingredientes) {
    final TextEditingController nomeController = TextEditingController(text: ingredientes.nome);
    final TextEditingController precoController = TextEditingController(text: ingredientes.preco.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Adicional'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
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
                ingredientes.nome = nomeController.text;
                ingredientes.preco = double.parse(precoController.text);

                try {
                  controller.updateIngrediente(ingredientes, ingredientes.id);
                  Navigator.pushNamed(context, '/ingrediente'); 
                } catch (e) {
                  print('Erro ao atualizar adicional: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
