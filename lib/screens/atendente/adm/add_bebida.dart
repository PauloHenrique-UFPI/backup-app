import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veneza/blocs/validations_mixin.dart';
import 'package:veneza/components/loading.dart';
import 'package:veneza/models/rest_client.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddBebida extends StatefulWidget {
  const AddBebida({super.key});

  @override
  State<AddBebida> createState() => _AddBebidaState();
}

class _AddBebidaState extends State<AddBebida> with ValidationsMixin {
  final _formKey = GlobalKey<FormState>();
  final _sabor = TextEditingController();
  final _ingredientes = TextEditingController();
  final _preco = TextEditingController();
  final _img = TextEditingController();
  final httpClient = GetIt.I.get<RestClient>();
  final TextEditingController _quantidadeController = TextEditingController(text: '1');
  int _quantidade = 1;

  void _incrementQuantidade() {
    setState(() {
      _quantidade++;
      _quantidadeController.text = _quantidade.toString();
    });
  }

  void _decrementQuantidade() {
    setState(() {
      if (_quantidade > 0) {
        _quantidade--;
        _quantidadeController.text = _quantidade.toString();
      }
    });
  }

  String? _validarQuantidade(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    final int? quantidade = int.tryParse(value);
    if (quantidade == null) {
      return 'Por favor, insira um número inteiro';
    }
    if (quantidade < 0) {
      return 'A quantidade não pode ser negativa';
    }
    return null;
  }

  final spinkit = const SpinKitWaveSpinner(
    color: Colors.red,
    size: 50.0,
  );
  File? _image;

  Future add(String nome, String img, String litros, String preco, String qtd) async {
    String mensagem;
    double intTryParse = double.tryParse(preco) ?? 0.00;
    int qtdInt = int.tryParse(qtd) ?? 0;
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    String? token = _sharedPreferences.getString('token');
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Loading();
        },
      );

      FormData formData = FormData.fromMap({
        "nome": nome,
        "litros": litros,
        "preco": intTryParse,
        "promocao": false,
        "img": await MultipartFile.fromFile(_image!.path, filename: "image.jpg"),
        "qtd": qtdInt
      });

      Response response = await Dio().post(
        'https://api-veneza.onrender.com/criar-bebida',
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
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
                  Navigator.pushNamed(context, '/bebida');
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
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
      CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
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
            style: TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 26, 25, 25)),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _sabor,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nome da Bebida (ex: Pepsi)',
                        labelText: 'Nome *',
                      ),
                      onSaved: (String? value) {},
                      validator: (value) => validacaoCompleta(
                        [
                          () => isNotEmpty(value),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Por favor, Selecione uma Imagem !",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color.fromARGB(255, 40, 6, 134),
                      ),
                    ),
                    if (_image != null)
                      Image.file(
                        _image!,
                        height: 300,
                        width: 300,
                      ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.image, color: Color.fromARGB(255, 202, 77, 77)),
                            ),
                            WidgetSpan(
                              child: SizedBox(width: 8),
                            ),
                            TextSpan(
                              text: "Imagem",
                              style: TextStyle(
                                color: Color.fromARGB(255, 202, 77, 77),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: _ingredientes,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Infome o volume da bebida (ex: 2 Litros)',
                        labelText: 'Volume *',
                      ),
                      validator: (value) => validacaoCompleta(
                        [
                          () => isNotEmpty(value),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: _preco,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Preço *",
                      ),
                      validator: (value) => validacaoCompleta(
                        [
                          () => isNotEmpty(value),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _decrementQuantidade,
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: _quantidadeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Qtd",
                              isDense: true,
                            ),
                            validator: _validarQuantidade,
                            onChanged: (value) {
                              setState(() {
                                _quantidade = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _incrementQuantidade,
                        ),
                      ],
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
                add(_sabor.text, _img.text, _ingredientes.text, _preco.text, _quantidadeController.text),
              }
          },
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
