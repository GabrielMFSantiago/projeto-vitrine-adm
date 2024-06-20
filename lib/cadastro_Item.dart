import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'item.dart';
import 'database.dart';

class Formulario extends StatefulWidget {
  final Map? itemSelecionado;
  final Database? db;
  final String? userId;

  Formulario({Key? key, this.itemSelecionado, this.db, this.userId}) : super(key: key);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  TextEditingController nomeitemCtrl = TextEditingController();
  TextEditingController corCtrl = TextEditingController();
  TextEditingController tamanhoCtrl = TextEditingController();
  TextEditingController descricaoCtrl = TextEditingController();
  TextEditingController precoCtrl = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  String imageUrl = '';
  bool isImageUploading = false;
  String? id;

  @override
  void initState() {
    super.initState();

    if (widget.itemSelecionado != null) {
      id = widget.itemSelecionado!['id'];
      nomeitemCtrl.text = widget.itemSelecionado!['nomeitem'] ?? '';
      corCtrl.text = widget.itemSelecionado!['cor'] ?? '';
      tamanhoCtrl.text = widget.itemSelecionado!['tamanho'] ?? '';
      descricaoCtrl.text = widget.itemSelecionado!['descricao'] ?? '';
      precoCtrl.text = widget.itemSelecionado!['preco'] ?? '';
      imageUrl = widget.itemSelecionado!['img'] ?? '';
    }
  }

  Future<void> _uploadImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: source);

    if (file == null) return;

    setState(() {
      isImageUploading = true;
    });

    final uniqueFileName = '${id}_${DateTime.now().millisecondsSinceEpoch}';
    final ref = firebase_storage.FirebaseStorage.instance.ref().child('images/$uniqueFileName');
    final uploadTask = ref.putFile(File(file.path));
    final taskSnapshot = await uploadTask;

    if (taskSnapshot.state == firebase_storage.TaskState.success) {
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    }

    setState(() {
      isImageUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastre seu produto...', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
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
                decoration: const InputDecoration(labelText: "Cores disponíveis"),
              ),
              TextField(
                controller: tamanhoCtrl,
                decoration: const InputDecoration(labelText: "Tamanhos disponíveis"),
              ),
              TextField(
                controller: descricaoCtrl,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              TextField(
                controller: precoCtrl,
                decoration: const InputDecoration(labelText: "Preço"),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _uploadImage(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                        IconButton(
                          onPressed: () {
                            _uploadImage(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.image),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: 600.0,
                      height: 500.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (imageUrl.isNotEmpty)
                            Image.network(
                              imageUrl,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const Center(child: Text('Erro ao carregar a imagem'));
                              },
                            ),
                          if (isImageUploading)
                            const CircularProgressIndicator(),
                          if (imageUrl.isEmpty && !isImageUploading)
                            const Center(child: Text('Adicione sua imagem aqui!')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nomeitemCtrl.text.trim().isNotEmpty) {
                    final db = Database();
                    final item = Item(
                      nomeitemCtrl.text,
                      corCtrl.text,
                      tamanhoCtrl.text,
                      descricaoCtrl.text,
                      precoCtrl.text,
                      imageUrl,
                      user?.uid,
                    );
                    if (id == null) {
                      await db.incluir(item);
                    } else {
                      await db.editar(id!, item);
                    }
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Gravar', style: TextStyle(color: Colors.white)),
              ),
              if (id != null)
                ElevatedButton(
                  onPressed: () async {
                    if (id != null) {
                      final db = Database();
                      await db.excluir(id!);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
