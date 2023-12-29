import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:vitrine/utils/validator.dart';
import 'item.dart';
import 'database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Formulario extends StatefulWidget {
  Formulario(param0,
      {Key? key, this.ItemSelecionado, this.db, this.user, this.userId})
      : super(key: key);

  Map? ItemSelecionado;
  Database? db;

  User? user = FirebaseAuth.instance.currentUser;
  String? userId;

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  TextEditingController nomeitemCtrl = TextEditingController(text: '');
  TextEditingController corCtrl = TextEditingController(text: '');
  TextEditingController tamanhoCtrl = TextEditingController(text: '');
  TextEditingController descricaoCtrl = TextEditingController(text: '');
  TextEditingController precoCtrl = TextEditingController(text: '');
  User? user = FirebaseAuth.instance.currentUser;

  String imageUrl = '';

  bool isImageUploading = false;
  String? id;

  String? get userId => user?.uid;

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_null_comparison
    if (widget.ItemSelecionado!['id'].toString() != null &&
        widget.userId.toString() != null) {
      id = widget.ItemSelecionado!['id'].toString();
      nomeitemCtrl.text = widget.ItemSelecionado!['nomeitem'] != null
          ? widget.ItemSelecionado!['nomeitem'].toString()
          : '';
      corCtrl.text = widget.ItemSelecionado!['cor'] != null
          ? widget.ItemSelecionado!['cor'].toString()
          : '';
      tamanhoCtrl.text = widget.ItemSelecionado!['tamanho'] != null
          ? widget.ItemSelecionado!['tamanho'].toString()
          : '';
      descricaoCtrl.text = widget.ItemSelecionado!['descricao'] != null
          ? widget.ItemSelecionado!['descricao'].toString()
          : '';
      precoCtrl.text = widget.ItemSelecionado!['preco'] != null
          ? widget.ItemSelecionado!['preco'].toString()
          : '';
      imageUrl = widget.ItemSelecionado!['img'].toString();
      user = widget.userId as User?;
    }
  }

  Future<void> _uploadImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file == null) return;

    setState(() {
      isImageUploading = true;
    });

    String uniqueFileName =
        '${widget.ItemSelecionado!['id']}_${DateTime.now().millisecondsSinceEpoch}';

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/$uniqueFileName');
    firebase_storage.UploadTask uploadTask = ref.putFile(File(file.path));
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

    if (taskSnapshot.state == firebase_storage.TaskState.success) {
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    }

    setState(() {
      isImageUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
            title: const Text(
              'Cadastre seu produto...',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
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
                  controller: nomeitemCtrl,
                  decoration: const InputDecoration(labelText: "Nome do Item"),
                ),
                TextField(
                    controller: corCtrl,
                    decoration:
                        const InputDecoration(labelText: "Cores disponíveis")),
                TextField(
                    controller: tamanhoCtrl,
                    decoration: const InputDecoration(
                        labelText: "Tamanhos disponíveis")),
                TextField(
                    controller: descricaoCtrl,
                    decoration: const InputDecoration(labelText: "Descrição")),
                TextField(
                    controller: precoCtrl,
                    decoration: const InputDecoration(labelText: "Preço")),
                Container(
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
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nomeitemCtrl.text.trim() != "") {
                      Database db = Database();
                      if (widget.ItemSelecionado!['id'] == null) {
                        db.incluir(Item(
                            nomeitemCtrl.text,
                            corCtrl.text,
                            tamanhoCtrl.text,
                            descricaoCtrl.text,
                            precoCtrl.text,
                            imageUrl,
                            userId as User?));
                      } else {
                        db.editar(
                          id!,
                          Item(
                            nomeitemCtrl.text,
                            corCtrl.text,
                            tamanhoCtrl.text,
                            descricaoCtrl.text,
                            precoCtrl.text,
                            imageUrl,
                            userId as User?,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                  ),
                  child: const Text('Gravar'),
                ),
                if (widget.ItemSelecionado!['id'] != null)
                  ElevatedButton(
                    onPressed: () async {
                      if (id != null) {
                        Database db = Database();
                        db.excluir(id!);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, 
                      onPrimary: Colors.red, 
                    ),
                    child: const Text('Excluir'),
                  ),
              ],
            ),
          ),
        ));
  }
}
