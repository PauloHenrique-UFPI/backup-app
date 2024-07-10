// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/controllers/controllers_pedido.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/repositories/pedido_repository.dart';


class FazerPedidoPage extends StatefulWidget {
  final Pedido pedido;
  const FazerPedidoPage({super.key, required this.pedido});

  @override
  State<StatefulWidget> createState() {
    return PedidoPageState();
  }
}

class PedidoPageState extends State<FazerPedidoPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarAtendente(),
        drawer: DrawerAtendente(),
          body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 10, bottom: 12),
              child: Column(
                children: [
                  Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0), 
                    border: Border.all(
                      color: const Color.fromARGB(255, 15, 15, 15), // Define a cor da borda como azul
                      width: 2.0, // Define a largura da borda
                    ),
                  ),
                  child: const Text(
                    "Informações do cliente",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                 padding: const EdgeInsets.only(
                  left: 15, right: 0, top: 0, bottom: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                       const Text(
                          "Status do Pedido:  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.pedido.status,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                       const Text(
                          "Email:  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.pedido.cliente.email,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                       const Text(
                          "Endereço:  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.pedido.cliente.endereco,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                   
                  
                ), 
              ),
              const SizedBox(height: 15),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0), 
                    border: Border.all(
                      color: const Color.fromARGB(255, 15, 15, 15), // Define a cor da borda como azul
                      width: 2.0, // Define a largura da borda
                    ),
                  ),
                  child: const Text(
                    "Informações do Pagamento",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ), 

                const SizedBox(height: 10),
                Padding(
                 padding: const EdgeInsets.only(
                  left: 15, right: 0, top: 0, bottom: 0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                       Text(
                          "Método de pagamento:  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Dinheiro",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                       const Text(
                          "Preço:  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'R\$ ${widget.pedido.precoTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(width: 40),
                        const Text(
                          "Local:  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${widget.pedido.local}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ), 
              ),

              const SizedBox(height: 15),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0), 
                    border: Border.all(
                      color: const Color.fromARGB(255, 15, 15, 15), // Define a cor da borda como azul
                      width: 2.0, // Define a largura da borda
                    ),
                  ),
                  child: const Text(
                    "Tamanhos  𝓔  Sabores",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                for (var produto in widget.pedido.produtos)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Tamanho: ${produto.tamanho}, Preço: R\$ ${produto.precoTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4), // Espaçamento entre o título e os sabores
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            for (var sabor in produto.sabores)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  '${sabor.sabor}, ${sabor.categoria}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 15),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0), 
                    border: Border.all(
                      color: const Color.fromARGB(255, 15, 15, 15), // Define a cor da borda como azul
                      width: 2.0, // Define a largura da borda
                    ),
                  ),
                  child: const Text(
                    "Observações",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.pedido.descricao,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
          ],
        ),
      ),
      
        );
  }
}
