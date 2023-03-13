import 'package:flutter/material.dart';

import '../componentes/side_menu.dart';

class SuportePage extends StatefulWidget {
  const SuportePage({Key? key}) : super(key: key);

  @override
  State<SuportePage> createState() => _SuportePageState();
}

class _SuportePageState extends State<SuportePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 65, 124),
      appBar: AppBar(
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          title: Text('Escolha uma forma de contato:')),
      body: Container(
        child: Center(
          child: Text(
            'Tel: (22)99878-6284 \nTel: (22)99282-3204 \n\nEmail: danilloneto98@gmail.com',
            textDirection: TextDirection.ltr,
            style: TextStyle(
                height: 2,
                fontSize: 30,
                fontStyle: FontStyle.italic,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
  //  body: Container(
     //     child: Image.asset("images/btnfoguete.png"),
     //   )