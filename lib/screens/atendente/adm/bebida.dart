import 'package:flutter/material.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_bebida.dart';
import 'package:veneza/models/bebidas.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/repositories/bebida_repository.dart';

class BebidaPage extends StatefulWidget {
  const BebidaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BebidaPageState();
  }
}

class BebidaPageState extends State<BebidaPage> {
  final controller = ControllerBebidas(
    bebidaRepository: BebidaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

  @override
  void initState() {
    controller.buscarBebida();
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
            child: _Body(bebidas: controller.bebida),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () => { Navigator.pushNamed(context, "/addBebida") },
            child: const Icon(Icons.add),
          ),
        );
      },
    );

  }
}

class _Body extends StatelessWidget {
  final List<Bebida> bebidas;
  const _Body({required this.bebidas});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bebidas.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showEditDialog(context, bebidas[index]),
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: <Widget>[
                  // Conteúdo à esquerda
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(bebidas[index].img),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 15), 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Título
                        Text(
                          bebidas[index].nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 29, 118, 233),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          bebidas[index].litros,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color.fromARGB(118, 29, 7, 128),
                          ),
                        ),
                        const Divider(color: Color.fromARGB(255, 0, 0, 0)),
                        Text(
                          'Preço: R\$ ${bebidas[index].preco.toStringAsFixed(2)}',
                        ),
                        const Divider(color: Colors.black),
                     
                      ],
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

void _showEditDialog(BuildContext context, Bebida bebida) {
    final TextEditingController nomeController = TextEditingController(text: bebida.nome);
    final TextEditingController litrosController = TextEditingController(text: bebida.litros);
    final TextEditingController precoController = TextEditingController(text: bebida.preco.toString());
    final TextEditingController qtdController = TextEditingController(text: bebida.qtd.toString());
    final controlador = ControllerBebidas(
    bebidaRepository: BebidaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text(
                'Editar Bebida',
                textAlign: TextAlign.center,
              ),
                        content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(bebida.img),
                        fit: BoxFit.cover,
                        width: 150,
                        height: 100,
                      ),
                    ),
                SizedBox(height: 10), 
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome: '),
                ),
                TextField(
                  controller: litrosController,
                  decoration: const InputDecoration(labelText: 'Volume: '),
                ),
                
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: null,
                  controller: precoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Preço: *",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: null,
                  controller: qtdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Quantidade: *",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
               
                      
                const SizedBox(
                  height: 5,
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
                child: const Text('Deletar'),
                onPressed: () {
                  try {
                    controlador.deletarBebida(bebida.id);
                    Navigator.pushNamed(context, '/initial'); 
                  } catch (e) {
                    print('Erro ao deletar pizza: $e');
                  }
                },
              ),
              TextButton(
                child: const Text('Salvar'),
                onPressed: () {
                  bebida.nome = nomeController.text;
                  bebida.litros = litrosController.text;
                  bebida.preco = double.parse(precoController.text);
                  bebida.qtd = int.parse(qtdController.text);

                  try {
                    controlador.updateBebida(bebida, bebida.id);
                    Navigator.pushNamed(context, '/initial'); 
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

  