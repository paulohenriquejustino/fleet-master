import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/pages/adm/adm_principal.dart';

class RegisterAdminPage extends StatefulWidget {
  const RegisterAdminPage({Key? key}) : super(key: key);

  @override
  State<RegisterAdminPage> createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerAdmin() async {
    try {
      // Cria um usuário com email e senha
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Salva o usuário no Firestore com o papel de "admin_principal"
        await _firestore.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': user.email,
          'role': 'admin_principal', // Definindo o papel como "admin_principal"
        });

        // Exibe uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário admin cadastrado com sucesso!")),
        );

        // Redireciona para a tela do Admin Principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminPrincipalPage()),
        );
      }
    } catch (e) {
      // Exibe uma mensagem de erro caso o cadastro falhe
      print("Error registering admin: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro: Falha ao cadastrar usuário!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Admin Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerAdmin,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
