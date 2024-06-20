// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item.dart';
import 'Loja.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

 initiliaze() {
    _firestore = FirebaseFirestore.instance;
  }


  Future<void> incluir(Item c) async {
    User? user = FirebaseAuth.instance.currentUser;

    final itemData = <String, dynamic>{
      "nomeitem": c.nomeitem,
      "cor": c.cor,
      "tamanho": c.tamanho,
      "descricao": c.descricao,
      "preco": c.preco,
      "img": c.img,
      "userId": user?.uid,
    };

    try {
      await _firestore.collection('Items').add(itemData);
      print('Documento adicionado com sucesso');
    } catch (e) {
      print('Erro ao adicionar documento: $e');
    }
  }

  Future<void> editar(String id, Item c) async {
    final itemData = <String, dynamic>{
      "nomeitem": c.nomeitem,
      "cor": c.cor,
      "tamanho": c.tamanho,
      "descricao": c.descricao,
      "preco": c.preco,
      "img": c.img,
      "userId": c.userItem,
    };

    try {
      DocumentReference productRef = _firestore.collection('Items').doc(id);

      DocumentSnapshot productSnapshot = await productRef.get();
      if (productSnapshot.exists) {
        await productRef.update(itemData);
        print('Item atualizado com sucesso');
      } else {
        print('Item não encontrado');
      }
    } catch (e) {
      print('Erro ao atualizar o item: $e');
    }
  }

  Future<void> excluir(String id) async {
    try {
      DocumentReference productRef = _firestore.collection('Items').doc(id);

      await productRef.delete();
      print('Item excluído com sucesso');
    } catch (e) {
      print('Erro ao excluir o documento: $e');
    }
  }




Future<void> editarLoja(String id, Loja j) async {
    User? user = FirebaseAuth.instance.currentUser;

    print("id -----> $id");
    final Loja = <String, dynamic>{
      "nomeitem": j.nome,
      "cnpj": j.cnpj,
      "endereco": j.endereco,
      "nomeProprietario": j.nomeProprietario,
      "telefone": j.telefone,
      "userLoja": j.userLoja,
    };

    try {
      DocumentReference lojaRef = _firestore
          .collection('usersadm')
          .doc(user?.uid);

    DocumentSnapshot lojaSnapshot = await lojaRef.get();
    if (lojaSnapshot.exists) {
      await lojaRef.update(Loja);
      print('Loja $lojaSnapshot atualizado com sucesso');
    } else {
      print('Loja $lojaSnapshot não atualizado');
    }
      
    } catch (e) {
      print('Erro ao atualizar a Loja: $e');
    }
  }

/*
  Future<List> listar() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await _firestore.collection('Items').orderBy("nomeitem").get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "nomeitem": doc['nomeitem'],
            "cor": doc["cor"],
            "tamanho": doc["tamanho"],
            "descricao": doc["descricao"],
            "preco": doc["preco"],
            "img": doc["img"],
            "userId": doc["userId"],
          };
          docs.add(a);
        }
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

*/


Future<List> listar() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    // Se o usuário não estiver logado, retornar uma lista vazia ou lançar uma exceção
    print("Usuário não está logado.");
    return [];
  }

  print("Usuário logado com userId: ${user.uid}");

  QuerySnapshot querySnapshot;
  List docs = [];
  try {
    querySnapshot = await _firestore
        .collection('Items')
        .where('userId', isEqualTo: user.uid) // Filtrar pelo userId do usuário logado
        .orderBy('nomeitem')
        .get();
    
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "nomeitem": doc['nomeitem'],
          "cor": doc["cor"],
          "tamanho": doc["tamanho"],
          "descricao": doc["descricao"],
          "preco": doc["preco"],
          "img": doc["img"],
          "userId": doc["userId"],
        };
        docs.add(a);
      }
    } else {
      print("Nenhum documento encontrado para o userId: ${user.uid}");
    }
  } catch (e) {
    print('Erro ao buscar documentos: $e');
  }
  return docs;
}











  Future<Map<String, dynamic>?> getLojaInfo(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('usersadm').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Erro ao buscar informações da loja: $e');
      return null;
    }
  }

  Future<void> getData() async {
    CollectionReference usersadm = FirebaseFirestore.instance.collection('usersadm');
    QuerySnapshot querySnapshot = await usersadm.get();

    querySnapshot.docs.forEach((doc) {
      print(doc.data());
    });
  }
}
