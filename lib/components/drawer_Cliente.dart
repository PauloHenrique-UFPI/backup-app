import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCliente extends StatelessWidget {
  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.orange,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
              Navigator.pushNamed(context, '/homeCliente');
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Pizzaria',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        decoration: TextDecoration.underline, 
                      ),
                    ),
                    TextSpan(
                      text: 'Veneza',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        decoration: TextDecoration.underline, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
          ListTile(
            title: Text(
              'Meus Pedidos'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/meusPedidos');
            },
          ),
          ListTile(
            title: Text(
              'Realizar Pedido'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward), 
            onTap: () {Navigator.pushNamed(context, '/realizarPedido');},
          ),
          ListTile(
            title: Text(
              'Promoção'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {Navigator.pushNamed(context, '/promocao');},
          ),
          const SizedBox(height: 15),

          IconButton(
            onPressed: () => {
              logout(),
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false)
              },
            icon: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Icon(Icons.logout, size: 35),
                  SizedBox(width: 5), 
                  Text('Logout', style: TextStyle(fontSize: 25)), 
                ],
              ),
            ),
          ),
          ],
        ),
      );
  }
}
