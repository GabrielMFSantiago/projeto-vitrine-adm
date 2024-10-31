
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
      'cidade': c.cidade,
      "timestamp": DateTime.now().toUtc().subtract(Duration(hours: 3)).toIso8601String(), // Ajusta o horário para Brasília
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
    "timestamp": DateTime.now().toUtc().subtract(Duration(hours: 3)).toIso8601String(), // Ajusta o horário para Brasília
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


// Método para obter a cidade do usuário a partir de 'usersadm'
Future<String?> getUserCidade(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('usersadm').doc(userId).get();
    return userDoc.data()?['cidade'] as String?;
  }



Future<List> listar() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("Usuário não está logado.");
    return [];
  }

  print("Usuário logado com userId: ${user.uid}");

  QuerySnapshot querySnapshot;
  List docs = [];
  try {
    querySnapshot = await _firestore
        .collection('Items')
        .where('userId', isEqualTo: user.uid) 
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
          "timestamp": doc["timestamp"],
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
