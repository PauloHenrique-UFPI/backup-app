import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_borda.dart';
import 'package:veneza/models/borda.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:veneza/repositories/borda_repository.dart';

class BordaPage extends StatefulWidget {
  const BordaPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BordaPageState();
  }
}

class BordaPageState extends State<BordaPage> {
  final controller = ControllerBorda(
    bordaRepository: BordaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

  @override
  void initState() {
    controller.buscarBorda();
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
            child: _Body(borda: controller.borda, controller: controller),
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
          title: const Text('Adicionar Borda'),
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
                  controller.addBorda(nomeController.text, precoController.text);
                  Navigator.pushNamed(context, '/borda'); 
                } catch (e) {
                  print('Erro ao adicionar borda: $e');
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
  final List<Borda> borda;
  final ControllerBorda controller;

  const _Body({required this.borda, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de itens por linha
        crossAxisSpacing: 10, // Espaçamento horizontal entre os itens
        mainAxisSpacing: 10, // Espaçamento vertical entre os itens
        childAspectRatio: 3 / 2, // Proporção da largura para a altura dos itens
      ),
      itemCount: borda.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showEditDialog(context, borda[index]),
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(6.0),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    borda[index].nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 29, 118, 233),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'R\$ ${borda[index].preco.toStringAsFixed(2)}',
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

  void _showEditDialog(BuildContext context, Borda borda) {
    final TextEditingController nomeController = TextEditingController(text: borda.nome);
    final TextEditingController precoController = TextEditingController(text: borda.preco.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Borda'),
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
                // Atualizar os dados da borda
                borda.nome = nomeController.text;
                borda.preco = double.parse(precoController.text);

                try {
                  controller.updateBorda(borda, borda.id);
                  Navigator.pushNamed(context, '/borda'); 
                } catch (e) {
                  print('Erro ao atualizar borda: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
