import 'package:flutter/material.dart';

class AppBarCliente extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
              Navigator.pushNamed(context, '/meusPedidos');
            },
        ),
      ],
      backgroundColor: Colors.orange,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
