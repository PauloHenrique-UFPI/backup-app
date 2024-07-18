import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:veneza/components/appBar_Atendente.dart';
import 'package:veneza/components/drawer_Atendente.dart';
import 'package:veneza/components/texto_bf_campo.dart';
import 'package:veneza/components/texto_campo.dart';
import 'package:veneza/components/titulo_borda.dart';
import 'package:veneza/controllers/controllers_funcionario.dart';
import 'package:veneza/models/funcionarios.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:veneza/repositories/funcionario_repository.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdminPageState();
  }
}

class AdminPageState extends State<AdminPage> {
  final controller = ControllerFuncionario(
    funcionarioRepository: FuncionarioRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );
  List<String> _options = [
    'atendende',
    'admin'
  ];
    String? _selectedOption;

  final TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(pickedDate.toUtc());
      _dateController.text = formattedDate;
    }
  }

  DateTime? selectedDate;

  @override
  void initState() {
    controller.buscarFuncionario();
    super.initState();
  }

  var cep = MaskTextInputFormatter(
    mask: '###-####', 
    filter: { "#": RegExp(r'[0-9]') }, 
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBarAtendente(),
          drawer: DrawerAtendente(),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: _Body(funcionario: controller.funcionario, controller: controller),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () {
              _showAddDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }


  void _showAddDialog(BuildContext context) {
    final _email = TextEditingController();
    final _senha = TextEditingController();
    final _confSenha = TextEditingController();
    final _telefone = TextEditingController();
    final _cep = TextEditingController();
    final _endereco = TextEditingController();

    var maskFormatter = MaskTextInputFormatter(
    mask: '(##)# ####-####', 
    filter: { "#": RegExp(r'[0-9]') }, 
  );

  bool _obscureText = true;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 23, 187, 31),
            borderRadius: BorderRadius.circular(10.0), 
            border: Border.all(
              color: const Color.fromARGB(255, 15, 15, 15), 
              width: 2.0, 
            ),
          ),
          child: const Text(
            'Adicionar Funcionario',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(
                            height: 10,
                          ),
                   
                        TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          hintText: '2000-05-20T00:00:00.000Z',
                        ),
                        onTap: () => _selectDate(context),
                      ),

              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
                items: _options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                hint: Text('Selecione uma opção'), 
              ),
                
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                try {
                  Funcionario funcionario = Funcionario(
                    id: 1,
                    email: _email.text,
                    telefone: _telefone.text,
                    dataNascimento: _dateController.text,
                    cep: _cep.text,
                    endereco: _endereco.text,
                    tipo: _selectedOption ?? 'atendente'
                  );
                  controller.addFuncionario(funcionario, _senha.text);
                  // controller.addFuncionario(f, precoController.text);
                  // Navigator.pushNamed(context, '/borda'); 
                } catch (e) {
                  print('Erro ao adicionar borda: $e');
                } finally {
                   Navigator.pushNamed(context, '/initial'); 
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final List<Funcionario> funcionario;
  final ControllerFuncionario controller;

  const _Body({required this.funcionario, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        crossAxisSpacing: 5, 
        mainAxisSpacing: 5, 
        childAspectRatio: 3 / 2, 
      ),
      itemCount: funcionario.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showEditDialog(context, funcionario[index]),
          child: Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(6.0),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    funcionario[index].email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 29, 118, 233),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    funcionario[index].telefone,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Funcionario funcionario) {
    final TextEditingController nomeController = TextEditingController(text: funcionario.email);
    final TextEditingController precoController = TextEditingController(text: funcionario.cep.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes:'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(children: [
                  TextoBf(label: "Email: "),
                  
                ],),
                TextoCampo(label: funcionario.email),
                Row(children: [
                  TextoBf(label: "Telefone: "),
                  TextoCampo(label: funcionario.telefone)
                ],),
                Row(children: [
                  TextoBf(label: "Cargo: "),
                  TextoCampo(label: funcionario.tipo)
                ],),
                Row(children: [
                  TextoBf(label: "CEP: "),
                  TextoCampo(label: funcionario.cep)
                ],),
                Row(children: [
                   TextoBf(label: "Endereço: "),
                ],),
                TextoCampo(label: funcionario.endereco)
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Deletar'),
              onPressed: () {
                try {
                  controller.deletarFuncionario(funcionario.id);
                } finally {
                  Navigator.pushNamed(context, '/admin'); 
                }
                
              },
            ),
          ],
        );
      },
    );
  }
}
