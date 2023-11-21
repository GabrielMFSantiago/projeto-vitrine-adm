import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitrine/database.dart';

class InfoLojaPage extends StatefulWidget {
  final String? userId;

  InfoLojaPage(param0,
      {Key? key, this.LojaSelecionada, this.db, this.user, this.userId})
      : super(key: key);

   Map? LojaSelecionada;
  Database? db;
  
  User? user = FirebaseAuth.instance.currentUser;
 // String? userId; 

  @override
  _InfoLojaPageState createState() => _InfoLojaPageState();
}
class _InfoLojaPageState extends State<InfoLojaPage> {

  TextEditingController nomelojaCtrl = TextEditingController(text: '');
  TextEditingController enderecoCtrl = TextEditingController(text: '');
  TextEditingController nomeproprietarioCtrl = TextEditingController(text: '');
  TextEditingController telefoneCtrl = TextEditingController(text: '');
  
  User? user = FirebaseAuth.instance.currentUser;

  String? get userId => user?.uid;

   @override
  void initState() {
    super.initState();

    

  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}