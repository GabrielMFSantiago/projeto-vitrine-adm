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
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: const Text('Email Enviado'),
            content: const Text('Um email foi enviado para alterar a sua Senha!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o pop-up
                  Navigator.pop(context); // Fecha a página SenhaPage e retorna para a LoginPage
                },
                child: const Text(
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
        title: const Text('Redefina sua Senha...'), 
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, 
          children: [
            TextField(
              controller: emailController, 
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _resetPassword(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), 
              ),
              child: const Text(
                'Redefinir Senha',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            const SizedBox(height: 16), 
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), 
                );
              },
              child: const Text('Lembrou a senha? Clique aqui!'),
            ),
          ],
        ),
      ),
    );
  }
}
