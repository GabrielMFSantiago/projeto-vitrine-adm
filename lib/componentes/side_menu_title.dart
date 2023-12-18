import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitrine/widgets/infoloja_page.dart';
import 'package:vitrine/widgets/suporte_page.dart';
import 'package:flutter/services.dart';
import 'package:vitrine/database.dart';
class SideMenuTitle extends StatelessWidget {

  String? userId;
  
  SideMenuTitle(String? userid, {
    Key? key,
    this.db
  }) : super(key: key);
  
  //List docs = [];
  //List<bool> selectedLoja = List.generate(0, (_) => false);
  Database? db;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white54,
            height: 1,
          ),
        ),
        // ----------------------------------
        GestureDetector(
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            leading: SizedBox(
              height: 34,
              width: 34,
              child: Image.asset(
                "images/btnhome.png",
              ),
            ),
            title: const Text(
              "Home",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),
        // ----------------------------------

        ListTile(
          onTap: () {},
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Image.asset(
              "images/btndiamante.png",
            ),
          ),
          title: const Text(
            "Favoritos",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),
        // ----------------------------------

        ListTile(
          onTap: () {},
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Image.asset(
              "images/btnreservas.png",
            ),
          ),
          title: const Text(
            "Reservas",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),

        // ----------------------------------
        ListTile(
          onTap: () async {
            User? user = FirebaseAuth.instance.currentUser;
            //userId = user?.uid;
            // Adicione esta linha para obter as informações da loja
            
            //Map<String, dynamic>? lojaInfo = await db?.getLojaInfo(userId!);
            
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InfoLojaPage(userId: user?.uid,),
              ),
            );
          },
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Image.asset(
              "images/btninfo.png",
            ),
          ),
          title: const Text(
            "Informações da Loja",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),
        
        // ----------------------------------
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SuportePage(),
              ),
            );
          },
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Image.asset(
              "images/btnsuporte.png",
            ),
          ),
          title: const Text(
            "Suporte",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),
        // ----------------------------------
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Deseja realmente sair?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop(); // Fechar completamente o aplicativo
                      },
                      child: const Text("Sair"),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
            leading: SizedBox(
              height: 34,
              width: 34,
              child: Image.asset(
                "images/btnsair.png",
              ),
            ),
            title: const Text(
              "Sair",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ],
    );
  }
}
