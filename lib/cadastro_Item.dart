import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'item.dart';
import 'database.dart';

class Formulario extends StatefulWidget {
  Formulario({Key? key, this.ItemSelecionado, this.db}) : super(key: key);
  Map? ItemSelecionado;
  Database? db;
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? downloadUrl;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link: $urlDownload");
    imgCtrl = urlDownload as TextEditingController;

    setState(() {
      uploadTask = null;
    });
  }

  TextEditingController nomeitemCtrl = TextEditingController();
  TextEditingController corCtrl = TextEditingController();
  TextEditingController tamanhoCtrl = TextEditingController();
  TextEditingController descricaoCtrl = TextEditingController();
  TextEditingController precoCtrl = TextEditingController();
  TextEditingController imgCtrl = TextEditingController();

  String? id;
  @override
  void initState() {
    super.initState();

    if (widget.ItemSelecionado!['id'].toString() != null) {
      id = widget.ItemSelecionado!['id'].toString();
      nomeitemCtrl.text = widget.ItemSelecionado!['nomeitem'].toString();
      corCtrl.text = widget.ItemSelecionado!['cor'].toString();
      tamanhoCtrl.text = widget.ItemSelecionado!['tamanho'].toString();
      descricaoCtrl.text = widget.ItemSelecionado!['descricao'].toString();
      precoCtrl.text = widget.ItemSelecionado!['preco'].toString();
      imgCtrl.text = widget.ItemSelecionado!['img'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(leading: BackButton(onPressed: () {
          Navigator.pop(context);
        })),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pickedFile != null)
                  Expanded(
                    child: Container(
                        color: Colors.blue[100],
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
                  ),
                //SELECIONA A IMAGEM
                ElevatedButton(
                  onPressed: selectFile,
                  child: const Text("Selecionar imagem"),
                ),
                const SizedBox(height: 20),
                //GRAVAR A IMAGEM
                ElevatedButton(
                  onPressed: uploadFile,
                  child: const Text("Gravar imagem"),
                ),
                const SizedBox(height: 20),
                buildProgress(),
                TextField(
                    controller: nomeitemCtrl,
                    decoration:
                        const InputDecoration(labelText: "Nome do Item")),

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

                ElevatedButton(
                    onPressed: () {
                      if (nomeitemCtrl.text.trim() != "") {
                        Database db = Database();
                        if (widget.ItemSelecionado!['id'] == null) {
                          db.incluir(Item(
                              nomeitemCtrl.text,
                              corCtrl.text,
                              tamanhoCtrl.text,
                              descricaoCtrl.text,
                              precoCtrl.text,
                              imgCtrl.text));
                        } else {
                          db.editar(
                              id!,
                              Item(
                                  nomeitemCtrl.text,
                                  corCtrl.text,
                                  tamanhoCtrl.text,
                                  descricaoCtrl.text,
                                  precoCtrl.text,
                                  imgCtrl.text));
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Gravar'))
              ],
            ),
          ),
        ));
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                    child: Text(
                  '${(100 * progress).roundToDouble()}%',
                  style: const TextStyle(color: Colors.white),
                )),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });
}
