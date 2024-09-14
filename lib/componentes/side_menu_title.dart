import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitrine/pages/infoloja_page.dart';
import 'package:vitrine/pages/suporte_page.dart';
import 'package:flutter/services.dart';
import 'package:vitrine/database.dart';
class SideMenuTitle extends StatelessWidget {

  String? userId;
  
  SideMenuTitle(String? userid, {
    Key? key,
    this.db
  }) : super(key: key);
  
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
          onTap: () async {
            User? user = FirebaseAuth.instance.currentUser;
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
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar", style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text("Sair", style: TextStyle(color: Colors.black)),
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
