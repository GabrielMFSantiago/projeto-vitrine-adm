import 'package:flutter/material.dart';
import 'package:vitrine/widgets/login_page.dart';

// APP DE ADMINISTRADOR

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor blackSwatch = const MaterialColor(
      0xFF000000, // Valor hexadecimal da cor preta
      <int, Color>{
        50: Color(0xFF000000),
        100: Color(0xFF000000),
        200: Color(0xFF000000),
        300: Color(0xFF000000),
        400: Color(0xFF000000),
        500: Color(0xFF000000),
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000),
      },
    );

    return MaterialApp(
      title: 'Vitrine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: blackSwatch,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: blackSwatch,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            textStyle: const TextStyle(
              fontSize: 24.0,
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
        ),
        textTheme: const TextTheme(
          // ignore: deprecated_member_use
          headline1: TextStyle(
            fontSize: 46.0,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          // ignore: deprecated_member_use
          bodyText1: TextStyle(fontSize: 20),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
