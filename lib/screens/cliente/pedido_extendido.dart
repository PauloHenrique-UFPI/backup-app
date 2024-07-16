// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/appBar_Cliente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/components/drawer_Cliente.dart';
import 'package:veneza/components/texto_bf_campo.dart';
import 'package:veneza/components/texto_campo.dart';
import 'package:veneza/components/titulo_borda.dart';
import 'package:veneza/controllers/controllers_pedido.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/repositories/pedido_repository.dart';


class PedidoExpandidoClientePage extends StatefulWidget {
  final Pedido pedido;
  const PedidoExpandidoClientePage({super.key, required this.pedido});

  @override
  State<StatefulWidget> createState() {
    return PedidoPageState();
  }
}

class PedidoPageState extends State<PedidoExpandidoClientePage> {

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.04;
    return Scaffold(
    appBar: AppBarCliente(),
    drawer: DrawerCliente(),
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
                      TextoCampo(label: widget.pedido.cliente.endereco)
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
        ],
      ),
      ),
      ],
      ),
    ),
        
  );
  }
}
