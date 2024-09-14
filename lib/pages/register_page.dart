import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitrine/pages/verificacao_email_page.dart';
import 'package:vitrine/utils/fire_auth.dart';
import 'package:vitrine/utils/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final String _userId;
  final String? _lojaNome;

  RegisterPage({Key? key, required String userId, String? lojaNome})
      : _userId = userId,
        _lojaNome = lojaNome,
        super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState(_userId, _lojaNome);
}

class _RegisterPageState extends State<RegisterPage> {
  final String _userId;
  final String? _lojaNome;
  _RegisterPageState(this._userId, this._lojaNome);

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
  final _focusCidade = FocusNode();
  final _focusNomepropietario = FocusNode();
  final _focusTelefone = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  String? _selectedCity;

  Future<void> _createLojaDocument(
    String userId,
    String nomeLoja,
    String cnpj,
    String endereco,
    String cidade,
    String nomeProprietario,
    String email,
    String telefone) async {

  String telefoneCompleto = "+55$telefone";

  CollectionReference usersadm = FirebaseFirestore.instance.collection('usersadm');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  try {
    // Adiciona informações na coleção 'usersadm'
    await usersadm.doc(userId).set({
      'nome': nomeLoja,
      'cnpj': cnpj,
      'endereco': endereco,
      'cidade': cidade,
      'nomeProprietario': nomeProprietario,
      'email': email,
      'telefone': telefoneCompleto,
      'isAdm': true, // Define isAdm como true para a coleção 'usersadm'
    });

    // Adiciona informações na coleção 'users'
    await users.doc(userId).set({
      'email': email,
      'isAdm': true, // Define isAdm como true para a coleção 'users'
    });

  } catch (e) {
    print('Erro ao criar documentos: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNomeloja.unfocus();
        _focusCnpj.unfocus();
        _focusEndereco.unfocus();
        _focusCidade.unfocus();
        _focusNomepropietario.unfocus();
        _focusTelefone.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: const Text(
            'Cadastrando sua loja...',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        focusNode: _focusCidade,
                        validator: (value) => Validator.validateCidade(
                          cidade: value,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCity = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Cidade",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black),
                        isExpanded: true,
                        items: <String>['Itaperuna', 'Campos dos Goytacazes', 'Macaé']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        controller: _nomepropietarioTextController,
                        focusNode: _focusNomepropietario,
                        validator: (value) => Validator.validateNomepropietario(
                          nomepropietario: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Nome do Proprietário",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      TextFormField(
                        controller: _telefoneTextController,
                        focusNode: _focusTelefone,
                        validator: (value) => Validator.validateTelefone(
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
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
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
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
                                          password: _passwordTextController.text,
                                        );

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('A conta já existe para esse e-mail.'),
                                            ),
                                          );
                                        } else {
                                          await _createLojaDocument(
                                              user.uid,
                                              _nomelojaTextController.text,
                                              _cnpjTextController.text,
                                              _enderecoTextController.text,
                                              _selectedCity!,
                                              _nomepropietarioTextController.text,
                                              _emailTextController.text,
                                              _telefoneTextController.text,
                                          );

                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool('isRegistered', true);

                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VerificacaoEmailPage(user: user),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                    child: const Text(
                                      'Registrar',
                                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
