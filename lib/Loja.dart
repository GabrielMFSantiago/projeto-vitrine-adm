import 'package:firebase_auth/firebase_auth.dart';

class Loja {
  User? userLoja = FirebaseAuth.instance.currentUser;
  String nome;
  String cnpj;
  String endereco;
  String nomeProprietario;
  String telefone;
  Loja(
    this.nome,
    this.cnpj,
    this.endereco,
    this.nomeProprietario,
    this.telefone,
    this.userLoja,
  );
}
