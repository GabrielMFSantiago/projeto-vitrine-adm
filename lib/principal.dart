import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vitrine/componentes/side_menu.dart';
import 'firebase_options.dart';
import 'cadastro_Item.dart';
import 'database.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vitrine Principal',
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
      ),
      home: const MyHomePage(title: 'Sua Vitrine está aqui!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

StreamController<List<Map<String, dynamic>>?> searchResultsController =
    StreamController<List<Map<String, dynamic>>?>.broadcast();

class _MyHomePageState extends State<MyHomePage> {
  late Database db;
  List docs = [];
  List<bool> selectedItems = List.generate(0, (_) => false);
  final TextEditingController _filtragemController = TextEditingController();

  initialize() {
    db = Database();
    db.initiliase();
    db.listar().then((value) => {
          setState(() {
            docs = value; // Atualiza a lista de registros
            selectedItems = List.generate(docs.length, (_) => false);
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void _abrirFormulario(Map ItemSelec) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Formulario(
                  null,
                  ItemSelecionado: ItemSelec,
                ))).then((_) {
      setState(() {
        initialize();
      });
    });
  }

  void _filtrandoTudo(String query) {
    setState(() {
      if (query.isNotEmpty) {
        docs = docs.where((contact) {
          String nomeItem = contact['nomeitem'].toLowerCase();
          String cor = contact['cor'].toLowerCase();
          String tamanho = contact['tamanho'].toLowerCase();
          String descricao = contact['descricao'].toLowerCase();
          String preco = contact['preco'].toLowerCase();
          return nomeItem.contains(query.toLowerCase()) ||
              cor.contains(query.toLowerCase()) ||
              tamanho.contains(query.toLowerCase()) ||
              descricao.contains(query.toLowerCase()) ||
              preco.contains(query.toLowerCase());
        }).toList();
      } else {
        db.listar().then((value) => {
              setState(() {
                docs = value; // Retorna todos os registros
                selectedItems = List.generate(docs.length, (_) => false);
              })
            });
      }
      selectedItems = List.generate(docs.length, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("images/btnopcao.png"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SideMenu(),
              ),
            );
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white, // Cor do título da barra de aplicativos
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filtragemController,
              onChanged:
                  _filtrandoTudo, // Atualiza a lista de registros de acordo com o termo de pesquisa
              decoration: const InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                String nomeItem = docs[index]['nomeitem'];
                if (nomeItem.length > 15) {
                  nomeItem = '${nomeItem.substring(0, 15)}...';
                }
                return GestureDetector(
                  onTap: () {
                    Map<String, String> Item() => {
                          "id": docs[index]['id'],
                          "nomeitem": docs[index]['nomeitem'],
                          "cor": docs[index]['cor'],
                          "tamanho": docs[index]['tamanho'],
                          "descricao": docs[index]['descricao'],
                          "preco": docs[index]['preco'],
                          "img": docs[index]['img'],
                        };
                    _abrirFormulario(Item());
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            docs[index]['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                nomeItem,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SecularOne',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'R\$ ${docs[index]['preco']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SecularOne',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      //boão flutuante padrão
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          Map<String, String> mapNulo() => {"nomeitem": "", "img": ""};
          _abrirFormulario(mapNulo());
        },
        tooltip: 'Novo Item',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
