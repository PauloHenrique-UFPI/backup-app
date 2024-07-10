
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:veneza/models/rest_client.dart';

class RecuperacaoPage extends StatefulWidget {
  const RecuperacaoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RecuperacaoPageState();
  }
}

class _RecuperacaoPageState extends State<RecuperacaoPage> {
  final TextEditingController emailController = TextEditingController();
  final httpCliente = GetIt.I.get<RestClient>();

  Future add() async {
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Align(
        alignment: Alignment.center,
        child: Text('E-mail Enviado'),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300, // Limita a altura máxima do conteúdo
          maxWidth: 400, // Limita a largura máxima do conteúdo
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min, // Faz com que o Column ocupe o espaço mínimo necessário
          children: [
            Icon(
              Icons.check,
              color: Colors.green,
              size: 50.0,
            ),
            Text('O e-mail foi enviado com sucesso. Por favor, entre em seu e-mail e siga as instruções para recuperar sua senha.')
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
  }
);
    // } catch (error) {
    //   // ignore: use_build_context_synchronously
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Alerta'),
    //         content: Text('$error'),
    //         actions: [
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Adiciona um padding ao redor do conteúdo
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinha os widgets à esquerda
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Redefinir',
                  style: TextStyle(
                    fontSize: 32, // Tamanho da fonte do título
                    fontWeight: FontWeight.bold, // Deixa o texto em negrito
                    color: Colors.black, // Cor do texto
                  ),
                ),
                const Text(
                  'Minha Senha',
                  style: TextStyle(
                    fontSize: 32, // Tamanho da fonte do título
                    fontWeight: FontWeight.bold, // Deixa o texto em negrito
                    color: Colors.black, // Cor do texto
                  ),
                ),
                const SizedBox(height: 20), // Espaço entre o título e a descrição
                const Text(
                  'Para sua segurança, enviaremos um código de segurança para o e-mail cadastrado em nosso sistema, a fim de proceder com a redefinição de sua senha. (Observação: Certifique-se de que o e-mail utilizado é o mesmo que está cadastrado no sistema.)', 
                  style: TextStyle(
                    fontSize: 18, // Tamanho da fonte da descrição
                    color: Color.fromARGB(255, 119, 110, 110), // Cor do texto
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Center(
                      child: ElevatedButton(
                      onPressed: () {
                      add();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 3, 16, 199)), // Fundo transparente
                        foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)), // Cor do texto e ícone
                        side: MaterialStateProperty.all(
                          const BorderSide(
                            color:  Color.fromARGB(255, 2, 2, 2),
                            width: 2.0, // Aumentar a espessura da borda
                          )
                        ),// Borda branca
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), 
                          )
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white.withOpacity(0.2); // Cor ao pressionar
                            }
                            return null; // Defer to the widget's default.
                          }
                        ),
                        elevation: MaterialStateProperty.all(0), 
                         minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                      ),
                      child: const Text(
                          'Enviar',  
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1), 
                            fontSize: 18, // Aumentar o tamanho do texto
                          ),
                        ),
                    )

                    ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 174, 132),
      );
  }
}
