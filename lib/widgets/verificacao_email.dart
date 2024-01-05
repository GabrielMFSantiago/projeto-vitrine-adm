import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:vitrine/utils/fire_auth.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    _checkEmailVerification(); // Adiciona a verificação no início
  }

  Future<void> _checkEmailVerification() async {
    await _currentUser.reload();
    _currentUser = FirebaseAuth.instance.currentUser!;
    print('User email verified: ${_currentUser.emailVerified}');
    if (_currentUser.emailVerified) {
      // Se o email estiver verificado, navegue para a tela de login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remova a seta de voltar
        title: const Text('Verificação de login', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NOME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
                    'Email verificado',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Text(
                    'Email não verificado',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.red),
                  ),
            const SizedBox(height: 16.0),
            _isSendingVerification
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSendingVerification = true;
                          });
                          await _currentUser.sendEmailVerification();
                          setState(() {
                            _isSendingVerification = false;
                          });
                           // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                title: Text('Email Enviado'),
                                content: Text(
                                    'Um email de verificação foi enviado!'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Fecha o pop-up
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 255, 255)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Verificar email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await _checkEmailVerification();
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
