import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerAtendente extends StatelessWidget {

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
          ListTile(
            title: Text(
              'Gerenciar Pedidos'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/pedido');
            },
          ),
          ListTile(
            title: Text(
              'Gerenciar Pizzas'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward), 
            onTap: () {Navigator.pushNamed(context, '/pizza');},
          ),
          ListTile(
            title: Text(
              'Gerenciar Bebidas'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {Navigator.pushNamed(context, '/bebida');},
          ),
          ListTile(
            title: Text(
              'Gerenciar Opcionais'.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {Navigator.pushNamed(context, '/opcionais');},
          ),
          const SizedBox(height: 15),

          IconButton(
            onPressed: () => {
              logout(),
              Navigator.pushNamed(context, '/')
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
