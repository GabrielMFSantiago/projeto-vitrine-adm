import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:vitrine/Loja.dart';
import 'package:vitrine/database.dart';

// ignore: must_be_immutable
class InfoLojaPage extends StatefulWidget {
  
  final User? userId = FirebaseAuth.instance.currentUser;
  final Map? lojaSelecionada;
  
  InfoLojaPage(
      {Key? key, 
       this.lojaSelecionada,
       this.db,
      }): super(key: key);
      
  
  Database? db;
  
  @override
  _InfoLojaPageState createState() => _InfoLojaPageState();
}

class _InfoLojaPageState extends State<InfoLojaPage> {
  TextEditingController nomeLojaCtrl = TextEditingController(text: '');
  TextEditingController cnpjCtrl = TextEditingController(text: '');
  TextEditingController enderecoCtrl = TextEditingController(text: '');
  TextEditingController nomePropietarioCtrl = TextEditingController(text: '');
  TextEditingController telefoneCtrl = TextEditingController(text: '');
  
  User? user = FirebaseAuth.instance.currentUser;
  String? id;
  String? get userId => user?.uid;

  @override
  void initState() {
    super.initState();

    if (widget.userId != null) {
      widget.db?.getLojaInfo(widget.userId as String).then((lojaInfo) {
        if (lojaInfo != null) {
          setState(() {
            nomeLojaCtrl.text = lojaInfo['nome'] ?? '';
            cnpjCtrl.text = lojaInfo['cnpj'] ?? '';
            enderecoCtrl.text = lojaInfo['endereco'] ?? '';
            nomePropietarioCtrl.text = lojaInfo['nomeProprietario'] ?? '';
            telefoneCtrl.text = lojaInfo['telefone'] ?? '';
          });
        }
      });
    }

    // ignore: unnecessary_null_comparison
    if (widget.lojaSelecionada != null) {
      id = widget.lojaSelecionada!['id'].toString();
      nomeLojaCtrl.text = widget.lojaSelecionada!['nome'] != null
          ? widget.lojaSelecionada!['nome'].toString()
          : '';
      cnpjCtrl.text = widget.lojaSelecionada!['cnpj'] != null
          ? widget.lojaSelecionada!['cnpj'].toString()
          : '';
      enderecoCtrl.text = widget.lojaSelecionada!['endereco'] != null
          ? widget.lojaSelecionada!['endereco'].toString()
          : '';
      nomePropietarioCtrl.text = widget.lojaSelecionada!['nomeProprietario'] != null
          ? widget.lojaSelecionada!['nomeProprietario'].toString()
          : '';
      telefoneCtrl.text = widget.lojaSelecionada!['telefone'] != null
          ? widget.lojaSelecionada!['telefone'].toString()
          : '';
      //imageUrl = widget.lojaSelecionada!['img'].toString();
      user = widget.userId as User?;
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
            title: const Text('Informações da sua loja...'),
            leading: BackButton(onPressed: () {
              Navigator.pop(context);
            })),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nomeLojaCtrl,
                  decoration: const InputDecoration(labelText: "Nome da Loja"),
                ),
                TextField(
                    controller: cnpjCtrl,
                    decoration:
                        const InputDecoration(labelText: "CNPJ")),
                TextField(
                    controller: enderecoCtrl,
                    decoration: const InputDecoration(
                        labelText: "Endereco")),
                TextField(
                    controller: nomePropietarioCtrl,
                    decoration: const InputDecoration(labelText: "Nome Proprietário")),
                TextField(
                    controller: telefoneCtrl,
                    decoration: const InputDecoration(labelText: "Telefone")),
                /* Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //ADICIONAR IMAGEM COM CAMERA
                          IconButton(
                            onPressed: () {
                              _uploadImage(ImageSource.camera);
                            },
                            icon: const Icon(Icons.camera_alt),
                          ),

                          //ADICIONAR IMAGEM COM GALERIA

                          IconButton(
                            onPressed: () {
                              _uploadImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.image),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: 600.0,
                        height: 500.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (imageUrl.isNotEmpty)
                              Image.network(
                                imageUrl,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Center(
                                      child: Text('Erro ao carregar a imagem'));
                                },
                              ),
                            if (isImageUploading)
                              const CircularProgressIndicator(),
                            if (imageUrl.isEmpty && !isImageUploading)
                              const Center(
                                  child: Text('Adicione sua imagem aqui!')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), */
                ElevatedButton(
                  onPressed: () async {
                    if (nomeLojaCtrl.text.trim() != "") {
                      Database db = Database();
                      if (widget.lojaSelecionada!['id'] == null) {
                       db.editarLoja(
                          id!,
                          Loja(
                            nomeLojaCtrl.text,
                            cnpjCtrl.text,
                            enderecoCtrl.text,
                            nomePropietarioCtrl.text,
                            telefoneCtrl.text,
                            userId as User?,
                          ),
                        );
                      } else {
                        //não fazer nada
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Gravar'),
                ),
                if (widget.lojaSelecionada!['id'] != null)
                  ElevatedButton(
                    onPressed: () async {
                      if (id != null) {
                        Database db = Database();
                        db.excluir(id!);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Excluir'),
                  ),
              ],
            ),
          ),
        ));
  }
}