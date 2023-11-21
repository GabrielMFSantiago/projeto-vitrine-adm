import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import 'login_page.dart';

// Classe da página de redefinição de senha
class SenhaPage extends StatelessWidget {
  final TextEditingController emailController =
      TextEditingController(); 

  SenhaPage(); 

  // Função para redefinir a senha
  void _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text, // Envia um email para redefinir a senha
      );

      // Mostra um pop-up com a mensagem após o envio do email
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            title: Text('Email Enviado'),
            content: Text('Um email foi enviado para alterar a sua Senha!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o pop-up
                  Navigator.pop(context); // Fecha a página SenhaPage e retorna para a LoginPage
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error: $e'); // Exibe um erro, se ocorrer
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            true, 
        title: Text('Redefina sua Senha...'), 
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(
            16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, 
          children: [
            TextField(
              controller: emailController, 
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _resetPassword(context),
              child: Text(
                'Redefinir Senha',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 40), 
              ),
            ),
            SizedBox(height: 16), 
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()), 
                );
              },
              child: Text('Lembrou a senha? Clique aqui!'),
            ),
          ],
        ),
      ),
    );
  }
}
