import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitrine/widgets/verificacaco_email.dart';
import 'package:vitrine/utils/fire_auth.dart';
import 'package:vitrine/utils/validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nomelojaTextController = TextEditingController();
  final _cnpjTextController = TextEditingController();
  final _enderecoTextController = TextEditingController();
  final _nomepropietarioTextController = TextEditingController();
  final _telefoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusNomeloja = FocusNode();
  final _focusCnpj = FocusNode();
  final _focusEndereco = FocusNode();
  final _focusNomepropietario = FocusNode();
  final _focusTelefone = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNomeloja.unfocus();
        _focusCnpj.unfocus();
        _focusEndereco.unfocus();
        _focusNomepropietario.unfocus();
        _focusTelefone.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 231, 221),
        appBar: AppBar(
          title: Text('Cadastrando sua loja...'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nomelojaTextController,
                        focusNode: _focusNomeloja,
                        validator: (value) => Validator.validateNomeLoja(
                          nomeloja: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Nome da Loja",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _cnpjTextController,
                        focusNode: _focusCnpj,
                        validator: (value) => Validator.validateCnpj(
                          cnpj: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Cnpj",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        controller: _enderecoTextController,
                        focusNode: _focusEndereco,
                        validator: (value) => Validator.validateEndereco(
                          endereco: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Endereco",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        controller: _nomepropietarioTextController,
                        focusNode: _focusNomepropietario,
                        validator: (value) => Validator.validateNomepropietario(
                          nomepropietario: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Nome do Propietário",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        controller: _telefoneTextController,
                        focusNode: _focusTelefone,
                        validator: (value) => Validator.validateTelefone(
                          //ver validador
                          telefone: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Telefone",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: true,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Senha",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      //---------------------------------------------------BOTÂO REGISTRAR-SE-------------------------------------------------
                      const SizedBox(height: 32.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        User? user = await FireAuth
                                            .registerUsingEmailPassword(
                                          name: _nomelojaTextController.text,
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text,
                                        );

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user != null) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage(user: user),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Registrar-se',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ) //----------------------------------------------------------------------------------------------------
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
