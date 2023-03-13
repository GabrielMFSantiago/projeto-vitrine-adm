import 'package:flutter/material.dart';
import 'package:vitrine/componentes/side_menu.dart';
import 'package:vitrine/pages/loading_page.dart';
import 'package:vitrine/widgets/login_page.dart';
import 'package:vitrine/widgets/suporte_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitrine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 9, 177, 255),
        //primaryColor: Color.fromARGB(255, 56, 165, 101),
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 24.0,
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 46.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          bodyText1: const TextStyle(fontSize: 18.0),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
