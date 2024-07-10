import 'package:flutter/material.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';

class OpcionaisPage extends StatefulWidget {
  const OpcionaisPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return OpcionaisPageState();
  }
}

class OpcionaisPageState extends State<OpcionaisPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAtendente(),
      drawer: DrawerAtendente(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  return  SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Botão com imagem de fundo e texto
              Stack(
                children: [
                  Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 2), // Borda escura
                      image: const DecorationImage(
                        image: AssetImage('assets/images/borda.png'), // Caminho da sua imagem
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        'Bordas',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {Navigator.pushNamed(context, '/borda');},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15), // Espaçamento entre os botões
              Stack(
                children: [
                  Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 2), // Borda escura
                      image: const DecorationImage(
                        image: AssetImage('assets/images/adicionais.jpg'), // Caminho da sua imagem
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        'Adicionais',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {Navigator.pushNamed(context, '/ingrediente');},
                      ),
                    ),
                  ),
                ],
              ),
              // Adicione mais botões
            ],
          ),
        ),
      );
  }
}