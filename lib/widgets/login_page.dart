import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitrine/widgets/senha_page.dart';
import 'package:vitrine/widgets/register_page.dart';
import 'package:vitrine/utils/fire_auth.dart';
import 'package:vitrine/utils/validator.dart';
import 'package:vitrine/principal.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _isFirebaseInitialized = false;

   @override
  void initState() {
    super.initState();
    
    _initializeFirebase();
  }

  // Função para inicializar o Firebase
  Future<void> _initializeFirebase() async {
    if (!_isFirebaseInitialized) {
      await Firebase.initializeApp();
      setState(() {
        _isFirebaseInitialized = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Verificar se o Firebase foi inicializado antes de construir a interface
    if (!_isFirebaseInitialized) {
      return CircularProgressIndicator(); // ou outra tela de carregamento
    }

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "images/background5.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Color.fromARGB(137, 255, 255, 255),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset("images/LogoVitrine2.png"),
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) =>
                                  Validator.validateEmail(
                                email: value,
                              ),
                              decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              validator: (value) =>
                                  Validator.validatePassword(
                                password: value,
                              ),
                              decoration: InputDecoration(
                                hintText: "Senha",
                                prefixIcon: Icon(Icons.lock),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            _isProcessing
                                ? const CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            _focusEmail.unfocus();
                                            _focusPassword.unfocus();

                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isProcessing = true;
                                              });

                                              User? user = await FireAuth
                                                  .signInUsingEmailPassword(
                                                email:
                                                    _emailTextController
                                                        .text,
                                                password:
                                                    _passwordTextController
                                                        .text,
                                              );

                                              setState(() {
                                                _isProcessing = false;
                                              });

                                              if (user != null) {
                                                // Exibir ID do usuário ao fazer login
                                                print("SEU ID É: ${user.uid}");
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MyApp(),
                                                        ));
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'Entrar',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24.0),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage(
                                                  userId: FirebaseAuth
                                                      .instance.currentUser!.uid,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Registrar',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 50.0),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SenhaPage()),
                                );
                              },
                              child: Text('Esqueceu sua senha?'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
