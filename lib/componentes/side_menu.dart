import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'info_card.dart';
import 'side_menu_title.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: Color.fromARGB(255, 20, 65, 124),
        child: SafeArea(
          child: Column(
            children: [
              const InfoCard(
                nome: "Danillo Neto",
                cargo: "Gerente",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Escolha uma opção:".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              SideMenuTitle()
            ],
          ),
        ),
      ),
    );
  }
}
