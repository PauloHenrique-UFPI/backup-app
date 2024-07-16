import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/blocs/validations_mixin.dart';
import 'package:veneza/components/appBar_Cliente.dart';
import 'package:veneza/components/drawer_Cliente.dart';
import 'package:veneza/components/texto_bf_campo.dart';
import 'package:veneza/components/texto_campo.dart';
import 'package:veneza/components/titulo_borda.dart';
import 'package:veneza/controllers/controllers_bebida.dart';
import 'package:veneza/controllers/controllers_pizza.dart';
import 'package:veneza/models/bebidas.dart';
import 'package:veneza/models/pizzas.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:veneza/repositories/bebida_repository.dart';
import 'package:veneza/repositories/pizza_repository.dart';

class FazerPedidoPage extends StatefulWidget {
  const FazerPedidoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return PedidoPageState();
  }
}

class PedidoPageState extends State<FazerPedidoPage> with ValidationsMixin {
  final controllerPizza = ControllerPizzas(
    pizzaRepository: PizzaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );

  final controllerBebida = ControllerBebidas(
    bebidaRepository: BebidaRepository(
      restClient: GetIt.I.get<RestClient>(),
    ),
  );
  String emailCliente = '';
  String enderecoCliente = '';
  String cepCliente = '';
  String idCliente = '';
  String? selectedValue;
  final valor = TextEditingController();
  final observacao = TextEditingController();
  List<Pizza> pizzas = [];
  List<Bebida> bebidas = [];
  Map<String, bool> options = {};
  Map<String, bool> optionsBebida = {};

  String? _selectedOption;

  List<String> _options = [
    'dinheiro',
    'cartao de credito',
    'cartao de debito',
    'pix',
  ];

  @override
  void initState() {
    super.initState();
    carregaDados();
  }

  Future<void> carregaDados() async {
    await controllerPizza.buscarPizza();
    await controllerBebida.buscarBebida();
    await iniciaCliente();
    setState(() {
      pizzas = controllerPizza.pizza;
      bebidas = controllerBebida.bebida;
      options = {for (var pizza in pizzas) pizza.sabor: false};
      optionsBebida = {for (var bebida in bebidas) bebida.nome: false};
    });
  }

  Future<void> iniciaCliente() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      emailCliente = _sharedPreferences.getString('email_cliente') ?? '';
      enderecoCliente = _sharedPreferences.getString('endereco_cliente') ?? '';
      cepCliente = _sharedPreferences.getString('cep_cliente') ?? '';
      idCliente = _sharedPreferences.getString('id_cliente') ?? '';
    });
  }

  Future<void> add(
  String descricao, 
  String? tamanho, 
  String? formaPagamento, 
  String valor, 
  List<String> pizzasSelecionadas, 
  List<String> bebidasSelecionadas
    ) async {
      SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
      String? token = _sharedPreferences.getString('token');

      try {
        if (descricao.isEmpty) {
          descricao = "";
        }

        List<int> pizzasIds = pizzasSelecionadas.map((id) => int.parse(id)).toList();
        List<int> bebidasIds = bebidasSelecionadas.map((id) => int.parse(id)).toList();
        print("Pizzas: $pizzasIds");
        print("Bebidas: $bebidasIds");

        // Criação do corpo do pedido com as pizzas e bebidas
        Map<String, dynamic> body = {
          "status": "pendente",
          "idUsuario": int.parse(idCliente),
          "local": "entrega",
          "descricao": descricao,
          "formaPagamento": formaPagamento,
          "valor": double.parse(valor),
          "pizzas": [
            {
              "pizzaIds": pizzasIds,
              "tamanho": tamanho,
            }
          ],
          "bebidas": bebidasIds
        };

        // Enviar a requisição para a API
        Dio dio = Dio();
        Response response = await dio.post(
          'https://api-veneza.onrender.com/criar-pedido', // Substitua pela URL da sua API
          data: body,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          // Sucesso
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sucesso!'),
                content: Text('Pedido realizado com sucesso!'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/homeCliente');
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Algo deu errado
          throw Exception('Falha ao realizar o pedido');
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ops!'),
              content:  Text(error.toString()),
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
    double precoAtual = calcularPrecoAtual(); // Calcula o preço atual do pedido dinamicamente

    return Scaffold(
      appBar: AppBarCliente(),
      drawer: DrawerCliente(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TituloTexto(label: "Informações do Cliente"),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      TextoBf(label: "E-mail: "),
                      TextoCampo(label: emailCliente),
                    ],
                  ),
                  Row(
                    children: [
                      TextoBf(label: "Endereço: "),
                      TextoCampo(label: enderecoCliente),
                    ],
                  ),
                  Row(
                    children: [
                      TextoBf(label: "CEP: "),
                      TextoCampo(label: cepCliente),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TituloTexto(label: "Forma de Pagamento"),
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
                hint: Text('Selecione uma opção'), // Texto exibido quando nenhum item está selecionado
              ),

              
              if (_selectedOption == 'dinheiro')
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Troco para quanto ?'),
                  const SizedBox(height: 5),
                  SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: valor,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Troco *",
                        ),
                        validator: (value) => validacaoCompleta(
                        [
                          () => isNotEmpty(value),
                        ],
                      ),
                      ),
                      ),
                ],
              ),
              const SizedBox(height: 10),
              TituloTexto(label: "Observações"),
              const SizedBox(height: 15),
              TextFormField(
                      maxLines: null,
                      controller: observacao,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '(ex: Retirar as cebolas)',
                      ),
                    ),

              const SizedBox(height: 10),
              TituloTexto(label: "Tamanho"),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RadioOption(
                    title: 'Pequena (4 pedaços)',
                    value: 'P',
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                  RadioOption(
                    title: 'Média (6 pedaços)',
                    value: 'M',
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                  RadioOption(
                    title: 'Grande (8 pedaços)',
                    value: 'G',
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                  RadioOption(
                    title: 'Extra Grande (10 pedaços)',
                    value: 'GG',
                    groupValue: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                ],
              ),

              TituloTexto(label: "Selecione o Sabor"),
              TextoCampo(label: "(até 4 sabores)"),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 200.0, 
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: options.keys.map((String key) {
                      return Transform.scale(
                        scale: 0.9, // Reduz o tamanho do CheckboxListTile
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0), // Remove padding horizontal
                          title: Text(key),
                          value: options[key],
                          onChanged: (bool? value) {
                            setState(() {
                              options[key] = value!;
                              // Atualiza o preço ao selecionar/deselecionar uma pizza
                              precoAtual = calcularPrecoAtual();
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              TituloTexto(label: "Bebidas"),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 200.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: optionsBebida.keys.map((String key) {
                      return Transform.scale(
                        scale: 0.9, // Reduz o tamanho do CheckboxListTile
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0), // Remove padding horizontal
                          title: Text(key),
                          value: optionsBebida[key],
                          onChanged: (bool? value) {
                            setState(() {
                              optionsBebida[key] = value!;
                              // Atualiza o preço ao selecionar/deselecionar uma bebida
                              precoAtual = calcularPrecoAtual();
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          List<String> pizzasSelecionadas = [];
          List<String> bebidasSelecionadas = [];

          pizzas.forEach((pizza) {
            if (options[pizza.sabor] == true) {
              pizzasSelecionadas.add(pizza.id.toString());
            }
          });

          bebidas.forEach((bebida) {
            if (optionsBebida[bebida.nome] == true) {
              bebidasSelecionadas.add(bebida.id.toString());
            }
          });

          add(observacao.text, selectedValue, _selectedOption, valor.text, pizzasSelecionadas, bebidasSelecionadas);
        },
        label: Text('Realizar Pedido - R\$ ${precoAtual.toStringAsFixed(2)}'),
        backgroundColor: Colors.green.withOpacity(0.5), // Define a cor verde com 50% de transparência
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  double calcularPrecoAtual() {
    double precoTotal = 0.0;
    int saboresSelecionados = 0;
    
    // Calcula a quantidade de sabores selecionados
    for (var pizza in pizzas) {
      if (options[pizza.sabor] == true) {
        saboresSelecionados++;
      }
    }
    
    // Calcula o preço total com base na quantidade de sabores selecionados
    for (var pizza in pizzas) {
      if (options[pizza.sabor] == true) {
        double precoSabor = calcularPrecoPizza(pizza);
        precoTotal += precoSabor * (1 / saboresSelecionados);
      }
    }
    
    // Adiciona o preço das bebidas selecionadas
    for (var bebida in bebidas) {
      if (optionsBebida[bebida.nome] == true) {
        precoTotal += bebida.preco;
      }
    }
    
    return precoTotal;
  }

  double calcularPrecoPizza(Pizza pizza) {
    switch (selectedValue) {
      case 'P':
        return pizza.precos.p;
      case 'M':
        return pizza.precos.m;
      case 'G':
        return pizza.precos.g;
      case 'GG':
        return pizza.precos.gg;
      default:
        return 0.0; // Caso inesperado, retorna 0
    }
  }
}

class RadioOption extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const RadioOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.9, 
      child: RadioListTile<String>(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
