import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoLojaPage extends StatefulWidget {
  final String? userId;

  InfoLojaPage({Key? key, required this.userId}) : super(key: key);

  @override
  _InfoLojaPageState createState() => _InfoLojaPageState();
}

class _InfoLojaPageState extends State<InfoLojaPage> {
  late String _userId;
  late String _nomeLoja;
  late String _cnpj;
  late String _endereco;
  late String _nomeProprietario;
  late String _telefone;

@override
void initState() {
  super.initState();
  _userId = widget.userId ?? '';
  print('User ID in initState: $_userId');  
  _nomeLoja = ''; 
  _cnpj = '';
  _endereco = '';
  _nomeProprietario = '';
  _telefone = '';

  _loadLojaData(); 
}


Future<void> _loadLojaData() async {
  try {
    if (_userId.isNotEmpty) {
      DocumentSnapshot lojaDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (lojaDoc.exists) {
        setState(() {
          _nomeLoja = lojaDoc['nome'] ?? '';
          _cnpj = lojaDoc['cnpj'] ?? '';
          _endereco = lojaDoc['endereco'] ?? '';
          _nomeProprietario = lojaDoc['nomeProprietario'] ?? '';
          _telefone = lojaDoc['telefone'] ?? '';
        });
      }
    }
  } catch (e) {
    print('Erro ao carregar dados da loja: $e');
    setState(() {
      _nomeLoja = ''; // ou outro valor padrão
      _cnpj = '';
      _endereco = '';
      _nomeProprietario = '';
      _telefone = '';
    });
  }
}


  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Informações da Loja'),
        ),
        body: const Center(
          child: Text('O ID do usuário está vazio.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações da Loja'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome da Loja: $_nomeLoja'),
            const SizedBox(height: 8.0),
            Text('CNPJ: $_cnpj'),
            const SizedBox(height: 8.0),
            Text('Endereço: $_endereco'),
            const SizedBox(height: 8.0),
            Text('Nome do Proprietário: $_nomeProprietario'),
            const SizedBox(height: 8.0),
            Text('Telefone: $_telefone'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Adicione a navegação para a tela de edição aqui
              },
              child: const Text('Editar Informações'),
            ),
          ],
        ),
      ),
    );
  }
}
