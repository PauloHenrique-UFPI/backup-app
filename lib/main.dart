import 'package:flutter/material.dart';
import 'package:veneza/core/rest_client/service_locator.dart';
import 'package:veneza/models/pedidos.dart';
import 'package:veneza/screens/atendente/adm/add_bebida.dart';
import 'package:veneza/screens/atendente/adm/add_pizzza.dart';
import 'package:veneza/screens/atendente/adm/bebida.dart';
import 'package:veneza/screens/atendente/adm/borda.dart';
import 'package:veneza/screens/atendente/adm/ingrediente.dart';
import 'package:veneza/screens/atendente/adm/lista_pedido.dart';
import 'package:veneza/screens/atendente/adm/opcionais.dart';
import 'package:veneza/screens/atendente/adm/pedido_expandido.dart';
import 'package:veneza/screens/auth/login.dart';
import 'package:veneza/screens/auth/recuperacao.dart';
import 'package:veneza/screens/auth/sign.dart';
import 'package:veneza/screens/cliente/homeCliente.dart';
import 'package:veneza/screens/cliente/meusPedidos.dart';
import 'package:veneza/screens/cliente/pedido_extendido.dart';
import 'package:veneza/screens/cliente/promocao.dart';
import 'package:veneza/screens/cliente/realizarPedido.dart';
import 'package:veneza/screens/home/home.dart';
import 'package:veneza/screens/atendente/adm/pizza.dart';


void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Aplicativo',
      initialRoute: '/',  // Define a rota inicial
      routes: {
        "/": (context) => const LoginPage(), 
        "/initial": (context) => const HomePage(), 
        "/homeCliente": (context) => const HomeClientePage(), 
        "/recuperacao":(context) => const RecuperacaoPage(),
        "/sign":(context) => const SignPage(),
        "/pizza": (context) => const PizzaPage(),
        "/bebida": (context) => const BebidaPage(),
        "/opcionais": (context) => const OpcionaisPage(),
        "/borda": (context) => const BordaPage(),
        "/ingrediente": (context) => const IngredientePage(),
        "/pedido": (context) => const PedidoPage(),
        "/meusPedidos": (context) => const MeusPedidosPage(),
        "/promocao": (context) => const PromocaoPage(),
        "/addPizza":(context) => const AddPizza(),
        "/addBebida":(context) => const AddBebida(),
        "/realizarPedido":(context) => const FazerPedidoPage(),
        "/pedidoEx": (context) {
          final arg = ModalRoute.of(context)?.settings.arguments;
          return PedidoExpandidoPage(
            pedido: arg as Pedido,
          );
         },
         "/pedidoExCliente": (context) {
          final arg = ModalRoute.of(context)?.settings.arguments;
          return PedidoExpandidoClientePage(
            pedido: arg as Pedido,
          );
         },
         
      },
     
    );
  }
}
