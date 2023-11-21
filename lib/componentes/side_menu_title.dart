import 'package:flutter/material.dart';
import 'package:vitrine/cadastro_Item.dart';
import 'package:vitrine/principal.dart';
import 'package:vitrine/widgets/infoloja_page_OLD.dart';
import 'package:vitrine/widgets/login_page.dart';
import 'package:vitrine/widgets/register_page.dart';
import 'package:vitrine/widgets/suporte_page.dart';
import 'package:flutter/services.dart';

class SideMenuTitle extends StatelessWidget {

  final String? userId;

  const SideMenuTitle({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
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
            title: Text(
              "Home",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20),
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
          title: Text(
            "Favoritos",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
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
          title: Text(
            "Reservas",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.white12,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
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
                builder: (context) => InfoLojaPage(userId: userId),
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
          title: Text(
            "Informações da Loja",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20),
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
                builder: (context) => SuportePage(),
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
          title: Text(
            "Suporte",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
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
                  title: Text("Deseja realmente sair?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fechar o diálogo
                      },
                      child: Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop(); // Fechar completamente o aplicativo
                      },
                      child: Text("Sair"),
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
            title: Text(
              "Sair",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ],
    );
  }
}
