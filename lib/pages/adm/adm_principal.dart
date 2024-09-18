import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/pages/login.dart';

class AdminPrincipalPage extends StatefulWidget {
  const AdminPrincipalPage({super.key});

  @override
  _AdminPrincipalPageState createState() => _AdminPrincipalPageState();
}

class _AdminPrincipalPageState extends State<AdminPrincipalPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Função para cadastrar o ADM Secundário
  Future<void> _registerAdminSecundario() async {
    try {
      // Criar o usuário com Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      // Após criar o usuário, adicione o papel (role) ao Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': _nameController.text,
          'role': 'admin_secundario',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 3),
              content: Text('Administrador Secundário Cadastrado!')),
        );
      } else {
        throw Exception("Erro ao criar usuário.");
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        message = 'O e-mail já está em uso por outra conta.';
      } else {
        message = 'Erro: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 3), content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cadastrar administrador.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard ADM Principal",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de nome
              TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                    gapPadding: 10,
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                    gapPadding: 10,
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                autofillHints: const [AutofillHints.password],
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                focusNode: FocusNode(),
                autocorrect: false,
                enableSuggestions: false,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.blue),
                    gapPadding: 10,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: _registerAdminSecundario,
                child: const Text(
                  "Cadastrar ADM Secundário",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
