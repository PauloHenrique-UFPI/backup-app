import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/blocs/validations_mixin.dart';
import 'package:veneza/components/custom_title.dart';
import 'package:veneza/components/loading.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:veneza/named_routes.dart';

class AddPizza extends StatefulWidget {
  const AddPizza({super.key});

  @override
  State<AddPizza> createState() => _AddPizzaState();
}

class _AddPizzaState extends State<AddPizza> with  ValidationsMixin{
  final _formKey = GlobalKey<FormState>();
  final _sabor = TextEditingController();
  final _ingredientes = TextEditingController();
  final _precoP = TextEditingController();
  final _precoM = TextEditingController();
  final _precoG = TextEditingController();
  final _precoGG = TextEditingController();
  final _img = TextEditingController();
  final httpClient = GetIt.I.get<RestClient>();
  final spinkit = const SpinKitWaveSpinner(
    color: Colors.red,
    size: 50.0,
  );
  String? _selectedOption;

  List<String> _options = [
    'tradicional',
    'especial',
    'premium',
  ];
  File? _image;

  Future add(
      String sabor, String img, String ingredientes, String precoP, String precoM, String precoG, String precoGG, String? selecao) async {
      String mensagem;
      double preP = double.tryParse(precoP) ?? 0.00;
      double preM = double.tryParse(precoM) ?? 0.00;
      double preG = double.tryParse(precoG) ?? 0.00;
      double preGG = double.tryParse(precoGG) ?? 0.00;
      SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
      String? token = _sharedPreferences.getString('token');
  try {
     Map<String, dynamic> precos = {
      'P': preP,
      'M': preM,
      'G': preG,
      'GG': preGG,
    };

     // Convertendo o mapa de preços para JSON
    String precosJson = jsonEncode(precos);
    print('Preços JSON: $precosJson');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context = context;
        return const Loading();
      },
    );

    FormData formData = FormData.fromMap({
      "sabor": sabor,
      "ingredientes": ingredientes,
      "precos": precosJson,
      "categoria": selecao,
      "img": await MultipartFile.fromFile(_image!.path, filename: "image.jpg"),
    });

    Response response = await Dio().post(
        'https://api-veneza.onrender.com/criar-pizza',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print(response.data);
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sucesso!'),
            content: Text('mensagem'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushNamed(context, '/pizza');
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ops!'),
            content: const Text('Algo deu errado'),
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
    TextStyle _style() {
      return const TextStyle(
        fontFamily: 'RobotoMono',
        fontWeight: FontWeight.bold,
      );
    }

    Future<File?> _cropImage({required File imageFile}) async {
      CroppedFile? croppedImage =
          await ImageCropper().cropImage(sourcePath: imageFile.path);
      if (croppedImage == null) return null;
      return File(croppedImage.path);
    }

    Future _pickImage(ImageSource source) async {
      try {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) {
          return;
        }
        File? img = File(image.path);
        img = await _cropImage(imageFile: img);
        setState(() {
          _image = img;
        });
      } on PlatformException catch (e) {
        print(e);
      }
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Pizzaria Veneza',
              style: TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 26, 25, 25)),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 10, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(),
                    CustomTitle(text: "Informações do produto", color: Colors.orange, fontFamily: 'Georgia',),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _sabor,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Sabor da Pizza (ex: Calabresa)',
                        labelText: 'Sabor *',
                      ),
                      onSaved: (String? value) {},
                      validator: (value) => validacaoCompleta(
                        [
                          () => isNotEmpty(value),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_image != null)
                      Image.file(
                        _image!,
                        height: 300,
                        width: 300,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.image, color: Color.fromARGB(255, 202, 77, 77)),
                          ),
                           WidgetSpan(
                            child: SizedBox(width: 8), // Adiciona um espaço de 5 pixels
                          ),
                          TextSpan(
                            text: "Selecione uma Imagem",
                            style: TextStyle(
                              color: Color.fromARGB(255, 202, 77, 77),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: null,
                      controller: _ingredientes,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ingredientes da Pizza (ex: queijo...)',
                        labelText: 'Ingredientes *',
                      ),
                      validator: (value) => validacaoCompleta(
                        [
                          () => isNotEmpty(value),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        "Categoria da Pizza",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 146, 107, 49),
                        ),
                      ),
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
                    const SizedBox(height: 16), // Espaço entre os campos
                    const Divider(), // Linha divisória
                    CustomTitle(text: "Preço do produto", color: Colors.green, fontFamily: 'Georgia',),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: _precoP,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Preço P*",
                        ),
                        validator: (value) => validacaoCompleta(
                          [
                            () => isNotEmpty(value),
                          ],
                        ),
                      ),
                      ),

                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: _precoM,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Preço M*",
                        ),
                        validator: (value) => validacaoCompleta(
                          [
                            () => isNotEmpty(value),
                          ],
                        ),
                      ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: _precoG,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Preço G*",
                        ),
                        validator: (value) => validacaoCompleta(
                          [
                            () => isNotEmpty(value),
                          ],
                        ),
                      ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200, // Define a largura desejada
                      child: TextFormField(
                        maxLines: null,
                        controller: _precoGG,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Preço GG*",
                        ),
                        validator: (value) => validacaoCompleta(
                          [
                            () => isNotEmpty(value),
                          ],
                        ),
                      ),
                      ),
                    
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onPressed: () => {
            if (_formKey.currentState!.validate())
              {
                add(_sabor.text, _img.text, _ingredientes.text, _precoP.text, _precoM.text, _precoG.text, _precoGG.text, _selectedOption),
              }
          },
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}