import 'package:flutter/material.dart';

class AppBarAtendente extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.receipt_long),
          onPressed: () {
              Navigator.pushNamed(context, '/pedido');
            },
        ),
      ],
      backgroundColor: Colors.orange,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
