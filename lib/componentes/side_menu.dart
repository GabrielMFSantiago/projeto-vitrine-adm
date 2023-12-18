import 'package:flutter/material.dart';
import 'package:vitrine/database.dart';
import 'side_menu_title.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}
class _SideMenuState extends State<SideMenu> {
  String? _imagePath;
  String? _lojaNome;
  late String _userId;
  Database? db;
  @override
  void initState() {
    super.initState();
    _initUserId();
  }

  Future<void> _initUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Usuário autenticado: ${user.uid}');
      setState(() {
        _userId = user.uid;
        _loadLojaNome();
        _loadImagePath();
      });
    } else {
      print('Usuário não autenticado');
    }
  }

  Future<void> _loadLojaNome() async {
    if (_lojaNome == null) {
      CollectionReference lojas = FirebaseFirestore.instance.collection('lojas');

      try {
        // Obtém o documento da loja associada ao usuário autenticado
        DocumentSnapshot lojaDoc = await lojas.doc(_userId).get();

        if (lojaDoc.exists) {
          setState(() {
            _lojaNome = lojaDoc['nome'];
          });
        }
      } catch (e) {
        print('Erro ao carregar o nome da loja: $e');
      }
    }
  }

 Future<void> _loadImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('image_path_$_userId');

    if (imagePath != null) {
      setState(() {
        _imagePath = imagePath;
      });
    }
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('image_path_$_userId', imagePath);
  }

   Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      final String destinationPath =
          '${appDocumentsDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      final File destinationFile = File(destinationPath);
      await destinationFile.writeAsBytes(await pickedFile.readAsBytes());

      setState(() {
        _imagePath = destinationPath;
      });

      // Salvar o caminho da imagem nas SharedPreferences
      await _saveImagePath(destinationPath);
    }
  }

  Future<void> _showImageChangeDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alterar Imagem de Perfil'),
          content: const Text('Você deseja alterar sua imagem de perfil?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Alterar'),
              onPressed: () {
                _pickImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     User? user = FirebaseAuth.instance.currentUser;
     String ? userid = user?.uid;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 0, 0, 0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showImageChangeDialog();
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: _imagePath != null
                              ? Image.file(
                                  File(_imagePath!),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "images/FotoPerfil.jpeg",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _lojaNome ?? "Nome da Loja",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 190, top: 32, bottom: 16),
                child: Text(
                  "Escolha uma opção:".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
               
               SideMenuTitle(userid, db: db,)
            ],
          ),
        ),
      ),
    );
  }
}
