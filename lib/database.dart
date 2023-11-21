// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  initiliase() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> incluir(Item c) async {
    User? user = FirebaseAuth.instance.currentUser;

    final Item = <String, dynamic>{
      "nomeitem": c.nomeitem,
      "cor": c.cor,
      "tamanho": c.tamanho,
      "descricao": c.descricao,
      "preco": c.preco,
      "img": c.img,
      "user": c.userItem,
    };
    _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('Items')
        .add(Item)
        .then((DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));

   
  }

//Editar itens do adm loja - Ok em fucionamento
  Future<void> editar(String id, Item c) async {
    User? user = FirebaseAuth.instance.currentUser;

    print("id -----> $id");
    final Item = <String, dynamic>{
      "nomeitem": c.nomeitem,
      "cor": c.cor,
      "tamanho": c.tamanho,
      "descricao": c.descricao,
      "preco": c.preco,
      "img": c.img,
      "user": c.userItem,
    };

    try {
      DocumentReference productRef = _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('Items')
          .doc(id);
    
    DocumentSnapshot productSnapshot = await productRef.get();
    if (productSnapshot.exists) {
      await productRef.update(Item);
      print('Item $productSnapshot atualizado com sucesso');
    } else {
      print('Item $productSnapshot não atualizado');
    }
      
    } catch (e) {
      print('Erro ao atualizar o Item: $e');
    }
  }
//Excluir itens do adm loja - Ok em funcionamento
 Future<void> excluir(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      DocumentReference productRef = _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('Items')
          .doc(id);

      await productRef.delete(); // Exclui o documento do Firestore

      print('Item $productRef Excluído com sucesso');
    } catch (e) {
      print('Erro ao excluir o documento: $e');
    }
  }

//Listar itens do adm loja - ok em funcionamento
  Future<List> listar() async {
    User? user = FirebaseAuth.instance.currentUser;

    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('Items')
          .orderBy("nomeitem")
          .get();
      _firestore.collection('Items').orderBy("nomeitem").get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "nomeitem": doc['nomeitem'],
            "cor": doc["cor"],
            "tamanho": doc["tamanho"],
            "descricao": doc["descricao"],
            "preco": doc["preco"],
            "img": doc["img"]
          };
          docs.add(a);
        }
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }
}
