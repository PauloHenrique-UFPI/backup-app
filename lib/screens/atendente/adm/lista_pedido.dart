import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_pedido.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/repositories/pedido_repository.dart';


class PedidoPage extends StatefulWidget {
  const PedidoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PedidoPageState();
  }
}

class PedidoPageState extends State<PedidoPage> {
  final controller = ControllerPedidos(
    pedidoRepository: PedidoRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

  @override
  void initState() {
    controller.buscarItens();
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
            child: _Body(pedido: controller.pedido),
          ),
          
        );
      },
    );

  }
}

class _Body extends StatelessWidget {
  final List<Pedido> pedido;
  const _Body({required this.pedido});

  @override
  Widget build(BuildContext context) {
    // Ordena os pedidos pelo campo dataHora em ordem decrescente
    pedido.sort((a, b) => DateTime.parse(b.dataHora).compareTo(DateTime.parse(a.dataHora)));

    return ListView.builder(
      itemCount: pedido.length,
      itemBuilder: (context, index) {
        // Converte a string de data e hora em DateTime e formata
        DateTime dateTime = DateTime.parse(pedido[index].dataHora);
        String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);

        return GestureDetector(
          onTap: () => {
            Navigator.pushNamed(context, '/pedidoEx', arguments: pedido[index]),
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
                        Text(
                          pedido[index].status,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 146, 107, 49),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pedido[index].endereco.endereco,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          pedido[index].local,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        const Divider(color: Colors.black),
                        const SizedBox(height: 5),
                        Text(
                          'R\$ ${pedido[index].precoTotal.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Status: ",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 3, 3, 3),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              radius: 125,
                              backgroundColor: _getStatusColor(pedido[index].status),
                            ),
                          ),
                        ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'cancelado':
        return Colors.red;
      case 'pendente':
        return Colors.yellow;
      case 'entregue':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
