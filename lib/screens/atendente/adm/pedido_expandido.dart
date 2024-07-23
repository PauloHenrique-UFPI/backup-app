// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/components/texto_bf_campo.dart';
import 'package:veneza/components/texto_campo.dart';
import 'package:veneza/components/titulo_borda.dart';
import 'package:veneza/controllers/controllers_pedido.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/repositories/pedido_repository.dart';


class PedidoExpandidoPage extends StatefulWidget {
  final Pedido pedido;
  const PedidoExpandidoPage({super.key, required this.pedido});

  @override
  State<StatefulWidget> createState() {
    return PedidoPageState();
  }
}

class PedidoPageState extends State<PedidoExpandidoPage> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.04;
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
                TituloTexto(label: "Informações do cliente"),
                const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                left: 15, right: 0, top: 0, bottom: 0),
                child: Column(
                children: [
                  Row(
                    children: [
                      TextoBf(label: 'Status do Pedido: '),
                      TextoCampo(label: widget.pedido.status)
                    ],
                  ),
                  Row(
                    children: [
                      TextoBf(label: 'E-mail: '),
                      TextoCampo(label: widget.pedido.cliente.email)
                    ],
                  ),
                  Row(
                    children: [
                      TextoBf(label: 'Endereço: '),
                      TextoCampo(label: widget.pedido.endereco.endereco)
                    ],
                  ),
                ],
              ), 
          ),
          const SizedBox(height: 15),
          TituloTexto(label: "Informações do Pagamento"),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(
            left: 15, right: 0, top: 0, bottom: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    TextoBf(label: 'Método de pagamento: '),
                    TextoCampo(label: 'Dinheiro')
                  ],
                ),
                Row(
                  children: [
                    TextoBf(label: "Preço: "),
                    TextoCampo(label: 'R\$ ${widget.pedido.precoTotal.toStringAsFixed(2)}'),
                    const SizedBox(width: 40),
                    TextoBf(label: 'Local: '),
                    TextoCampo(label: '${widget.pedido.local}')
                  ],
                ),
              ],
            ), 
          ),

          const SizedBox(height: 15),
          TituloTexto(label: "Tamanhos  𝓔  Sabores"),
          const SizedBox(height: 5),
          for (var produto in widget.pedido.produtos)
             Padding(
              padding: EdgeInsets.only(left: horizontalPadding,),
              child: Align(
                alignment: Alignment.topLeft,
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
                    SizedBox(height: 4),
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
                        
                        if (produto.adicionais.isNotEmpty)
                        TextoBf(label: "Ingredientes Adicionais: "),
                        for (var adicional in produto.adicionais)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              '${adicional.nome} - R\$ ${adicional.preco.toStringAsFixed(2)}',
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
            ),

          if (widget.pedido.bebidas.isNotEmpty && widget.pedido.bebidas[0].id != 0)
          Column(
            children: [
              SizedBox(height: 15),
              TituloTexto(label: "Bebidas"),
              SizedBox(height: 5),
              for (var adicional in widget.pedido.bebidas)
                Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            TextoCampo(label: adicional.nome),
                          ],
                        ),
                        Row(
                          children: [
                            TextoBf(label: 'Preço: '),
                            TextoCampo(label: 'R\$ ${adicional.preco.toStringAsFixed(2)}'),
                          ],
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
            ],
          ),
  
          const SizedBox(height: 15),
          TituloTexto(label: "Observações"),

          const SizedBox(height: 15),
          Padding(
              padding: EdgeInsets.only(left: horizontalPadding,),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextoBf(label: '${widget.pedido.descricao}'),

              ),
            ),

            const SizedBox(height: 30),
            if(widget.pedido.status == 'pendente')
            Column(
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showCancelConfirmationDialog(context, widget.pedido.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,            // Cor de fundo vermelha
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),  // Aumenta o tamanho do botão
                          textStyle: TextStyle(
                            fontSize: 18,                 // Tamanho do texto
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,  // Texto em negrito
                            color: Colors.white,          // Cor do texto branca
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                       ElevatedButton(
                        onPressed: () {
                          _showAceitarConfirmationDialog(context, widget.pedido.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,            // Cor de fundo vermelha
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),  // Aumenta o tamanho do botão
                          textStyle: TextStyle(
                            fontSize: 18,                 // Tamanho do texto
                          ),
                        ),
                        child: Text(
                          'Aceitar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,  // Texto em negrito
                            color: Colors.white,          // Cor do texto branca
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                       ElevatedButton(
                        onPressed: () {
                          _showEntregaConfirmationDialog(context, widget.pedido.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,            // Cor de fundo vermelha
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),  // Aumenta o tamanho do botão
                          textStyle: TextStyle(
                            fontSize: 18,                 // Tamanho do texto
                          ),
                        ),
                        child: Text(
                          'Entrega',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,  // Texto em negrito
                            color: Colors.white,          // Cor do texto branca
                          ),
                        ),
                      ),
                      
                  ],),
                  
              ] 
            )
          else if(widget.pedido.status == 'aceito')
            Column(
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showEntregaConfirmationDialog(context, widget.pedido.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,            // Cor de fundo vermelha
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),  // Aumenta o tamanho do botão
                            textStyle: TextStyle(
                              fontSize: 18,                 // Tamanho do texto
                            ),
                          ),
                          child: Text(
                            'Entrega',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,  // Texto em negrito
                              color: Colors.white,          // Cor do texto branca
                            ),
                          ),
                        ),
                        
                    ],),
                    
                ] 
              )

            
        ],
      ),
      ),
      ],
      ),
    ),
        
  );
  }
}

void _showCancelConfirmationDialog(BuildContext context, int id) {
  final controller = ControllerPedidos(
    pedidoRepository: PedidoRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Você tem certeza que deseja cancelar o pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Fecha o diálogo
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await controller.cancelarPedido(id);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('UwU'),
                      content: const Text('Pedido Cancelado !'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/initial');
                          },
                        ),
                      ],
                    );
                  },
                );
                  
                } catch (e) {
                 showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ops!'),
                      content: const Text('Algo deu errado'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
                } 
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }



void _showAceitarConfirmationDialog(BuildContext context, int id) {
  final controller = ControllerPedidos(
    pedidoRepository: PedidoRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Você tem certeza que deseja aceitar o pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Fecha o diálogo
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await controller.aceitarPedido(id);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('UwU'),
                      content: const Text('Pedido Aceito !'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/initial');
                          },
                        ),
                      ],
                    );
                  },
                );
                  
                } catch (e) {
                 showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ops!'),
                      content: const Text('Algo deu errado'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
                } 
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }

void _showEntregaConfirmationDialog(BuildContext context, int id) {
  final controller = ControllerPedidos(
    pedidoRepository: PedidoRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Deseja mandar o pedido para entrega?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Fecha o diálogo
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await controller.entregaPedido(id);
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('UwU'),
                      content: const Text('Pedido foi para Entrega !'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/initial');
                          },
                        ),
                      ],
                    );
                  },
                );
                  
                } catch (e) {
                 showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ops!'),
                      content: const Text('Algo deu errado'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
                } 
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }