import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.nome, required this.cargo})
      : super(key: key);

  final String nome, cargo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        nome,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        cargo,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
