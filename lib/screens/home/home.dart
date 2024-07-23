import 'package:flutter/material.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_pizza.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/models/pizzas.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:veneza/repositories/pizza_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: _Body(pizzas: controller.pizza),
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
      itemCount: pizzas.length + 1, // Adiciona 1 ao itemCount para incluir o card da pizzaria
      itemBuilder: (context, index) {
        if (index == 0) {
          // Retorna o card com informações da pizzaria
          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Para bordas arredondadas
                  child: Image.asset(
                    "assets/images/pizza2.jpg", // Substitua pelo caminho da sua imagem
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.black54, // Fundo semitransparente para o texto
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: CircleAvatar(
                          radius: 125, 
                          backgroundImage: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    ),
                    Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pizzaria',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: 'Veneza',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                    const SizedBox(height: 15),
                    
                    const Text(
                      '📍 R. São Sebastião, 799 - Canto de Várzea, Picos-PI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white, // Cor do texto para contraste com o fundo
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Fechado Agora",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 202, 77, 77),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '18:00 - 02:00',
                            textAlign: TextAlign.center, // Centraliza o texto
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white, // Cor do texto para contraste com o fundo
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Ajusta o índice para acessar os pedidos corretamente
          final pedidoIndex = index - 1;
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
                          pizzas[pedidoIndex].sabor,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 146, 107, 49),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pizzas[pedidoIndex].ingredientes,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Preço: R\$ ${pizzas[pedidoIndex].precos.g}',
                        ),
                        const SizedBox(height: 5),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 5), 
                        // Text(
                        //   'R\$ ${pizzas[pedidoIndex].preco.toStringAsFixed(2)}',
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(pizzas[pedidoIndex].img),
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
        }
      },
    );
  }
}
