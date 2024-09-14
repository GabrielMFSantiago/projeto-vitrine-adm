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
  late String _cidade;

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
    _cidade = '';

    _loadLojaData();
  }

  Future<void> _loadLojaData() async {
    try {
      if (_userId.isNotEmpty) {
        DocumentSnapshot lojaDoc = await FirebaseFirestore.instance
            .collection('usersadm')
            .doc(_userId)
            .get();

        if (lojaDoc.exists) {
          setState(() {
            _nomeLoja = lojaDoc['nome'] ?? '';
            _cnpj = lojaDoc['cnpj'] ?? '';
            _endereco = lojaDoc['endereco'] ?? '';
            _nomeProprietario = lojaDoc['nomeProprietario'] ?? '';
            _telefone = lojaDoc['telefone'] ?? '';
            _cidade = lojaDoc['cidade'] ?? '';
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
        _cidade = '';
      });
    }
  }

  _editarInformacoes() async {
    TextEditingController enderecoController = TextEditingController(text: _endereco);
    TextEditingController telefoneController = TextEditingController(text: _telefone.substring(3)); // Remove o +55
    String novaCidade = _cidade; // Variável para a cidade selecionada

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Informações'),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: novaCidade.isEmpty ? null : novaCidade,
                items: ['Itaperuna', 'Campos dos Goytacazes', 'Macaé']
                    .map((cidade) => DropdownMenuItem(
                          value: cidade,
                          child: Text(cidade),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    novaCidade = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Nova Cidade'),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: 'Novo Endereço'),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Novo Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (telefoneController.text.length == 11) {
                  String telefoneAtualizado = '+55${telefoneController.text}';
                  
                  await FirebaseFirestore.instance
                      .collection('usersadm')
                      .doc(_userId)
                      .update({
                    'endereco': enderecoController.text,
                    'telefone': telefoneAtualizado,
                    'cidade': novaCidade,
                  });

                  await _loadLojaData();

                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erro'),
                        content: Text('O telefone deve ter 11 dígitos!'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Alterar', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Informações da Loja', style: TextStyle(color: Colors.white)),
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
        title: const Text('Informações da Loja', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editarInformacoes,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background5.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.7), 
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.80,
              child: Card(
                color: Colors.white.withOpacity(0.7),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfo('Nome da Loja:', _nomeLoja),
                        _buildInfo('CNPJ:', _cnpj),
                        _buildInfo('Endereço:', '$_endereco'),
                        _buildInfo('Cidade:', '$_cidade'),
                        _buildInfo('Nome do Proprietário:', _nomeProprietario),
                        _buildInfo('Telefone:', _telefone),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
