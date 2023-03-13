import 'package:flutter/material.dart';
import 'package:vitrine/cadastro_Item.dart';
import 'package:vitrine/cadastro_loja.dart';
import 'package:vitrine/principal.dart';
import 'package:vitrine/widgets/login_page.dart';
import 'package:vitrine/widgets/register_page.dart';
import 'package:vitrine/widgets/suporte_page.dart';

class SideMenuTitle extends StatelessWidget {
  const SideMenuTitle({
    Key? key,
  }) : super(key: key);

  //irparaHome() {}

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
              //           Navigator.of(context).push(
              //            MaterialPageRoute(
              //                 builder: (context) => const MyApp(),
              //              ),
              //           );
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
              "images/btnlupa.png",
            ),
          ),
          title: Text(
            "Pesquisar",
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
              "images/btnfavorito.png",
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Formulario(),
              ),
            );
          },
          leading: SizedBox(
            height: 34,
            width: 34,
            child: Image.asset(
              "images/btncadastro.png",
            ),
          ),
          title: Text(
            "Adicionar Produto",
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
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
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
