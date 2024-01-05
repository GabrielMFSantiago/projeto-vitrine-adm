import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
      _nomeLoja = ''; 
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
          title: const Text('Informações da Loja',style: TextStyle(color: Colors.white),),
           backgroundColor: Colors.black,
           iconTheme: IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('O ID do usuário está vazio.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações da Loja',style: TextStyle(color: Colors.white),),
         backgroundColor: Colors.black,
         iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfo('Nome da Loja:', _nomeLoja),
            _buildInfo('CNPJ:', _cnpj),
            _buildInfo('Endereço:', _endereco),
            _buildInfo('Nome do Proprietário:', _nomeProprietario),
            _buildInfo('Telefone:', _telefone),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text('$value', style: TextStyle(fontSize: 20.0)),
        const SizedBox(height: 30.0),
      ],
    );
  }
}