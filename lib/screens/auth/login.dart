import 'package:flutter/material.dart';
import 'package:veneza/components/loading.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final httpCliente = GetIt.I.get<RestClient>();
   String token = '';
   String rule = '';
   int? id_cliente;

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  Future login(String email, String password) async {
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          context = context;
          return const Loading();
        }, 
      );
      final response = await httpCliente.post(
        '/login',
        {
          'email': email,
          'senha': password,
        },
      );
      
      token = response['token'];
      id_cliente = response['id'];
      rule = response['tipo'];
      await sharedPreferences.setString('token', token);

     if (rule == "user") {
        Navigator.pushNamed(context, '/homeCliente');
      } else  {
        Navigator.pushNamed(context, '/initial');
      } 
      
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

            title: const Text('Login Invalido'),
            content:  Text('Seu E-mail e/ou senha inválidos'),
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
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pizza2.jpg"), // Caminho para sua imagem de fundo
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8),
                BlendMode.dstATop,)
            ),
          ),
         child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        radius: 125, 
                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.black, // Cor do texto da label
                        ),
                        hintText: 'nome@gmail.com',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 3, 0, 0), // Cor do texto de hint
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Cor da borda normal
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Cor da borda quando o campo está focado
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Cor da borda quando o campo está habilitado
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black, // Cor do ícone
                        ),
                      ),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Digite seu e-mail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _senha,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(
                          color: Colors.black, // Cor do texto da label
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black, // Cor do texto de hint
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Cor da borda normal
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Cor da borda quando o campo está focado
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Cor da borda quando o campo está habilitado
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black, // Cor do ícone
                        ),
                      ),
                      validator: (senha) {
                        if (senha == null || senha.isEmpty) {
                          return 'Digite sua senha';
                        }
                        return null;
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/recuperacao');  // Rota para a tela de cadastro
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Use o menor espaço possível
                              children: [
                                const Text(
                                  "Esqueceu sua senha ?",
                                  style: TextStyle(
                                    color: Colors.blue,  // Cor do texto clicável
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 2,  // Espessura do sublinhado
                                  color: Colors.blue,  // Cor do sublinhado
                                  width: 150,  // Largura do sublinhado
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 15,
                    ),

                    Center(
                      child: ElevatedButton(
                      onPressed: () {
                       if (_formKey.currentState!.validate()) {
                          login(_email.text, _senha.text);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green), // Fundo transparente
                        foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)), // Cor do texto e ícone
                        side: MaterialStateProperty.all(
                          const BorderSide(
                            color:  Color.fromARGB(255, 255, 255, 255),
                            width: 3.0, // Aumentar a espessura da borda
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
                         minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                      ),
                      child: const Text(
                          'ENTRAR',  
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 18, // Aumentar o tamanho do texto
                          ),
                        ),
                    )

                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Não tem uma conta? ",
                            style: TextStyle(
                              color: Colors.white, // Ajuste a cor conforme o necessário
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign');  // Rota para a tela de cadastro
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Use o menor espaço possível
                              children: [
                                const Text(
                                  "CADASTRAR",
                                  style: TextStyle(
                                    color: Colors.blue,  // Cor do texto clicável
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 2,  // Espessura do sublinhado
                                  color: Colors.blue,  // Cor do sublinhado
                                  width: 80,  // Largura do sublinhado
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
       ),
    );
  }

}