import 'package:firebase_auth/firebase_auth.dart';

class Item {
  User? userItem = FirebaseAuth.instance.currentUser;
  String nomeitem;
  String cor;
  String tamanho;
  String descricao;
  String preco;
  String img;
  Item(
    this.nomeitem,
    this.cor,
    this.tamanho,
    this.descricao,
    this.preco,
    this.img,
    this.userItem,
  );
}
