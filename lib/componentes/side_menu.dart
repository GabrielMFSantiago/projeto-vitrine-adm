import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitrine/database.dart';
import 'side_menu_title.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool _isLoading = false;
  String? _imagePath;
  String? _lojaNome;
  late String _userId;
  Database? db;

  String imageUrl = '';
  bool isImageUploading = false;

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
      });
    } else {
      print('Usuário não autenticado');
    }
  }

  Future<void> _loadLojaNome() async {
    if (_lojaNome == null) {
      CollectionReference lojas = FirebaseFirestore.instance.collection('usersadm');

      try {
        DocumentSnapshot lojaDoc = await lojas.doc(_userId).get();

        if (lojaDoc.exists) {
          setState(() {
            _lojaNome = lojaDoc['nome'];
            _imagePath = lojaDoc['profileImage'];
          });
        }
      } catch (e) {
        print('Erro ao carregar o nome da loja: $e');
      }
    }
  }

  Future<void> _uploadImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file == null) return;

    setState(() {
      isImageUploading = true;
    });

    String uniqueFileName = '$_userId${DateTime.now().millisecondsSinceEpoch}';

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_images/$uniqueFileName');
    firebase_storage.UploadTask uploadTask = ref.putFile(File(file.path));
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

    if (taskSnapshot.state == firebase_storage.TaskState.success) {
      imageUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('usersadm').doc(_userId).update({
        'profileImage': imageUrl,
      });

      await _saveImagePath(imageUrl);

      setState(() {
        _imagePath = imageUrl;
        isImageUploading = false;
      });
    }
  }

  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('image_path_$_userId', imagePath);
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
            child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Alterar', style: TextStyle(color: Colors.black)),
            onPressed: () {
              _uploadImage(ImageSource.gallery); // Chame o método de upload da imagem
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
    String? userid = user?.uid;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 0, 0, 0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showImageChangeDialog();
                    
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: _imagePath != null
                                ? Image.network(
                                    _imagePath!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "images/FotoPerfil.jpeg",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (_isLoading) const CircularProgressIndicator(),                       
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                  Text(
                   _lojaNome ?? '',
                   style: const TextStyle(
                   color: Color.fromARGB(255, 255, 255, 255),
                   fontSize: 24,
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
                SideMenuTitle(userid, db: db),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
