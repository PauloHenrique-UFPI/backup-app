import 'package:flutter/material.dart';
import 'package:veneza/components/loading.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final httpCliente = GetIt.I.get<RestClient>();
  
  DateTime? selectedDate;

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(picked);
    }
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '(##)# ####-####', 
    filter: { "#": RegExp(r'[0-9]') }, 
  );

  var cep = MaskTextInputFormatter(
    mask: '###-####', 
    filter: { "#": RegExp(r'[0-9]') }, 
  );
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confSenha = TextEditingController();
  final _telefone = TextEditingController();
  final _cep = TextEditingController();
  final _endereco = TextEditingController();


  bool _obscureText = true;

  Future add(
    String email,
    String senha,
    String telefone,
    String data,
    String cep,
    String endereco,
    [text]
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          context = context;
          return const Loading();
        },
      );
    String mensagem;
     try {
      final response = await httpCliente.post('/criar', 
      {
        	"email": email, 
          "telefone": telefone, 
          "dataNascimento": data, 
          "senha": senha, 
          "cep": cep, 
          "endereco": endereco,
          "tipo": "user"
      });

      mensagem = response["message"];
      // ignore: use_build_context_synchronously
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: Text(mensagem),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          );
        },
      );

     } catch (error) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: const Text('Não foi possível cadastrar seu Usuário!'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sign');
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
              image: const AssetImage("assets/images/pizza2.jpg"), // Caminho para sua imagem de fundo
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8),
                BlendMode.dstATop,)
            ),
          ),
         child: Center(
        child: Container(
          
          padding: const EdgeInsets.all(15), // Espaçamento interno do Container
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 194, 162).withOpacity(0.8), // Cor de fundo do Container
            border: Border.all(
              color: const Color.fromARGB(255, 212, 78, 0),
              width: 2, // Espessura da borda
            ),
            borderRadius: BorderRadius.circular(12), // Bordas arredondadas
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Faz com que a Column ocupe o espaço mínimo necessário
                children: <Widget>[
                  const Row(children: [
                     Icon(
                      Icons.local_pizza,
                      color: Color.fromARGB(255, 212, 67, 0),
                      size: 35.0,
                    ),
                    SizedBox(
                          width: 10,
                        ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Cadastro de Usuário',
                        style: TextStyle(
                          fontSize: 25, // Aumenta o tamanho da fonte para 24
                          fontWeight: FontWeight.bold, // Opcional: torna o texto em negrito
                        ),
                      ),
                    ),
                    Icon(
                      Icons.local_pizza,
                      color: Color.fromARGB(255, 212, 67, 0),
                      size: 35.0,
                    ),
                    
                  ],),
                   
                const SizedBox(
                          height: 20,
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
                              color: Color.fromARGB(255, 0, 0, 0), // Cor da borda quando o campo está habilitado
                            ),
                          ),
                          
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'O campo não pode ser vazio';
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 10), // Espaço entre os campos de texto
                  TextFormField(
                  controller: _senha,
                  obscureText: _obscureText,  // Usa o estado para controlar a visibilidade
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),  // Alterna os ícones
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;  // Alterna o estado entre visível e oculto
                        });
                      },
                      color: Colors.black,
                    ),
                  ),
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confSenha,
                  obscureText: _obscureText,  // Usa o estado para controlar a visibilidade
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),  // Alterna os ícones
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;  // Alterna o estado entre visível e oculto
                        });
                      },
                      color: Colors.black,
                    ),
                  ),
                  validator: (senha) {
                    // ignore: unrelated_type_equality_checks
                    if (senha == null || senha.isEmpty || senha != _senha.text) {
                      return 'As senhas tem que ser iguais';
                    }
                    return null;
                  },
                ),
              
                 Row(
                        children: <Widget>[
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _telefone,
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    hintText: '(##)# ####-####',
                     labelStyle: TextStyle(
                            color: Colors.black, // Cor do texto da label
                          ),
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
                              color: Color.fromARGB(255, 0, 0, 0), // Cor da borda quando o campo está habilitado
                            ),
                          ),
                  ),
                  validator: (telefone) {
                          if (telefone == null || telefone.isEmpty) {
                            return 'O campo não pode ser vazio';
                          }
                          return null;
                        },
                ),
              ),
              const SizedBox(width: 10), // Espaçamento entre os campos
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    IconButton(
                  icon: const Icon(Icons.calendar_month,
                  size: 50.0,),
                  onPressed:  () => _pickDate(context),
                              ),
                 if (selectedDate != null)
                Text(' ${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(selectedDate!)}'),
                ] 
                ),
              ),
               
            ],
          ),
          const SizedBox(
                          height: 10,
                        ),
                  TextFormField(
                        controller: _cep,
                        inputFormatters: [cep],
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'CEP',
                          hintText: '###-####',
                          labelStyle: TextStyle(
                            color: Colors.black, // Cor do texto da label
                          ),
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
                              color: Color.fromARGB(255, 0, 0, 0), // Cor da borda quando o campo está habilitado
                            ),
                          ),
                          
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'O campo não pode ser vazio';
                          }
                          return null;
                        },
                      ),
                  const SizedBox(height: 10), // Espaço entre os campos de texto
                  TextFormField(
                    maxLines: 3,
                        controller: _endereco,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Endereço',
                          labelStyle: TextStyle(
                            color: Colors.black, // Cor do texto da label
                          ),
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
                              color: Color.fromARGB(255, 0, 0, 0), // Cor da borda quando o campo está habilitado
                            ),
                          ),
                          
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'O campo não pode ser vazio';
                          }
                          return null;
                        },
                      ),

          
                     
                  const SizedBox(height: 20), // Espaço antes do botão
                  ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              add(_email.text,_senha.text,_telefone.text,
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(selectedDate!),
                              _cep.text, _endereco.text
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 247, 247, 247)), // Fundo transparente
                            foregroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)), // Cor do texto e ícone
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color:  Color.fromARGB(255, 3, 114, 40),
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
                             minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                          ),
                          child: const Text(
                              'CADASTRAR',  
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0), 
                                fontSize: 18, // Aumentar o tamanho do texto
                              ),
                            ),
                        )
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