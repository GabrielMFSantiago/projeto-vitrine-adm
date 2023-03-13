import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vitrine/componentes/side_menu.dart';
import 'package:vitrine/componentes/side_menu_title.dart';
import 'package:vitrine/widgets/register_page.dart';
import 'firebase_options.dart';
import 'cadastro_Item.dart';
import 'database.dart';

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
        //colorSchemeSeed: Color.fromARGB(255, 56, 165, 101),
        colorSchemeSeed: Color.fromARGB(255, 9, 177, 255),
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

class _MyHomePageState extends State<MyHomePage> {
  late Database db;
  List docs = [];

  initialise() {
    db = Database();
    db.initiliase();
    db.listar().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  //boão flutuante padrão
  void _abrirFormulario(Map ItemSelec) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Formulario(
                  ItemSelecionado: ItemSelec,
                ))).then((_) {
      setState(() {
        initialise();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
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
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                print("docs[index]---> $docs[index]['id']");
                Map<String, String> Item() => {
                      "id": docs[index]['id'],
                      "nomeitem": docs[index]['nomeitem'],
                      "cor": docs[index]['cor'],
                      "tamanho": docs[index]['tamanho'],
                      "descricao": docs[index]['descricao'],
                      "preco": docs[index]['preco'],
                      "img": docs[index]
                          ['img'] //imagem ainda não esta sendo exibida/listada
                    };
                _abrirFormulario(Item());
              },
              onLongPress: () {
                db.excluir(docs[index]['id']);
                setState(() {
                  initialise();
                });
              },
              contentPadding: const EdgeInsets.only(right: 30, left: 36),
              title: Text(docs[index]['nomeitem']),
            ),
          );
        },
      ),
      //boão flutuante padrão
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 20, 65, 124),
        onPressed: () {
          Map<String, String> mapNulo() => {"nomeitem": "", "img": ""};
          _abrirFormulario(mapNulo());
        },
        tooltip: 'Novo Item',
        //child: const Icon(Icons.add),
        child: Image.asset("images/btnfoguete.png"),
      ),
    );
  }
}
