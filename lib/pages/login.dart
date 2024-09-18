// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/pages/adm/adm_principal.dart';
import 'package:prototipo/pages/adm/adm_secundario.dart';
import 'package:prototipo/pages/cliente_opcao_page.dart'; // Importe a página de home

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              const HeaderContainer(),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _textInput(
                        controller: _emailController,
                        hint: "Digite seu Email",
                        icon: Icons.email,
                      ),
                      _textInput(
                        controller: _passwordController,
                        hint: "Senha",
                        icon: Icons.vpn_key,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(top: 0, bottom: 0),
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: () {}, 
                        child: const Text("Esqueceu a senha?", style: TextStyle(color: Colors.white70, fontSize: 18)),)
                      ),
                      const SizedBox(height: 16),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.deepOrange,
                            ),
                            onPressed: _login,
                            child: const Text("LOGIN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                )),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white60,
      ),
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.deepOrange,
        style: const TextStyle(color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: Colors.deepOrange, width: 2, style: BorderStyle.none),
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Verificar se o documento do usuário existe no Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          if (userDoc.get('role') != null) {
            String role = userDoc.get('role');
            print("role: $role");

            // Check if the widget is still mounted before navigating
            if (!mounted) return;

            if (role == 'admin_principal') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminPrincipalPage()),
              );
            } else if (role == 'admin_secundario') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminSecundarioPage()),
              );
            } else if (role == 'cliente') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClienteOpcaoPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Erro: Papel do usuário não reconhecido!")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Erro: Campo 'role' ausente no documento do usuário!")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Erro: Documento do usuário não encontrado!")),
          );
        }
      }
    } catch (e) {
      print("Error logging in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro: Login ou senha incorretos!")),
      );
    }
  }
}

class HeaderContainer extends StatelessWidget {
  const HeaderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Criando um mysize para ajustar o tamanho da imagem
    final mySize = MediaQuery.of(context).size;
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black26, Colors.black12],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                height: mySize.height,
                width: mySize.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
