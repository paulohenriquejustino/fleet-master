import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/pages/login.dart';

class CadastrarClientePage extends StatefulWidget {
  const CadastrarClientePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastrarClientePageState createState() => _CadastrarClientePageState();
}

class _CadastrarClientePageState extends State<CadastrarClientePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Lista para armazenar os tipos de veículos selecionados
  final List<String> _selectedVehicles = [];

  final _formKey = GlobalKey<FormState>(); // Chave do formulário para validação

  // Função para cadastrar o cliente
  Future<void> _registerClient() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Criar o usuário com Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;

        // Após criar o usuário, adicione os dados ao Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'email': user.email,
          'name': _nameController.text,
          'role': 'cliente',
          'vehicleType':
              _selectedVehicles, // Adicionando a lista de tipos de veículos
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente cadastrado com sucesso!')),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
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
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar cliente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("CADASTRO DO USUÁRIO",
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Vinculando a chave do formulário
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira seu nome.';
                    }
                    return null;
                  },

                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  onSaved: (value) => _nameController.text = value!,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  autofocus: true,
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um email.';
                    }
                    return null;
                  },
                  onSaved: (value) => _emailController.text = value!,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _registerClient,
                  child: const Text("CADASTRAR USUÁRIO",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
