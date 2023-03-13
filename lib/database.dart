import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> incluir(Item c) async {
    final Item = <String, dynamic>{
      "nomeitem": c.nomeitem,
      "cor": c.cor,
      "tamanho": c.tamanho,
      "descricao": c.descricao,
      "preco": c.preco,
      "img": c.img
    };
    firestore.collection("Items").add(Item).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<void> editar(String id, Item c) async {
    print("id -----> $id");
    final Item = <String, dynamic>{
      "nomeitem": c.nomeitem,
      "cor": c.cor,
      "tamanho": c.tamanho,
      "descricao": c.descricao,
      "preco": c.preco,
      "img": c.img
    };
    try {
      await firestore.collection("Items").doc(id).update(Item);
    } catch (e) {
      print(e);
    }
  }

  excluir(String id) {
    firestore.collection("Items").doc(id).delete();
  }

  Future<List> listar() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore.collection('Items').orderBy("nomeitem").get();
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
