import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de lojas',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variaveis locais para controle do que é digitado.
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorCnpj = TextEditingController();
  final TextEditingController _controladorEndereco = TextEditingController();
  final TextEditingController _controladorProprietario =
      TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();

  //variável criada para limpar a tela.
  final fieldText = TextEditingController();
  void clearText() {
    fieldText.clear();
  }

//final CollectionReference _loja = FirebaseFirestore.instance.collection('loja');
  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _loja =
      FirebaseFirestore.instance.collection('loja');

  //Query teste = _loja.where('cnpj', isEqualTo: '123');
  // This widget is the root of your application.

  // ignore: unused_element
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _controladorNome.text = documentSnapshot['nome'];
      _controladorCnpj.text = documentSnapshot['cnpj'];
      _controladorEndereco.text = documentSnapshot['endereco'];
      _controladorProprietario.text = documentSnapshot['proprietario'];
      _controladorTelefone.text = documentSnapshot['telefone'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controladorNome,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _controladorCnpj,
                  decoration: const InputDecoration(labelText: 'CNPJ'),
                ),
                TextField(
                  controller: _controladorEndereco,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                ),
                TextField(
                  controller: _controladorProprietario,
                  decoration: const InputDecoration(labelText: 'Proprietario'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? nome = _controladorNome.text;
                    final String? cnpj = _controladorCnpj.text;
                    final String? endereco = _controladorEndereco.text;
                    final String? proprietario = _controladorProprietario.text;
                    if (nome != null &&
                        cnpj != null &&
                        endereco != null &&
                        proprietario != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _loja.add({
                          "nome": nome,
                          "cnpj": cnpj,
                          "endereco": endereco,
                          "proprietario": proprietario
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Loja incluída com sucesso.')));
                      }

                      if (action == 'update') {
                        // Update the product
                        await _loja.doc(documentSnapshot!.id).update({
                          "nome": nome,
                          "cnpj": cnpj,
                          "endereco": endereco,
                          "proprietario": proprietario
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Loja editada com sucesso.')));
                      }

                      // Clear the text fields
                      _controladorNome.text = '';
                      _controladorCnpj.text = '';
                      _controladorEndereco.text = '';
                      _controladorProprietario.text = '';
                      _controladorTelefone.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String lojaId) async {
    await _loja.doc(lojaId).delete();

    // Show a snackbar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loja excluída com sucesso.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _loja.snapshots(), //teste.snapshots
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['nome']),
                    subtitle: Text(documentSnapshot['cnpj']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Botão para incluir loja
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // Botão para exluir com incone já feito
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Adiciona nova loja e editar
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
