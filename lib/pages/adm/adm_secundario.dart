import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/pages/adm/adm_secundario_page.dart';
import 'package:prototipo/pages/cadastro/cadastro_veiculos.dart';
import 'package:prototipo/pages/checklist_disponiveis.dart';
import 'package:prototipo/pages/login.dart';
import 'package:prototipo/pages/veiculos_disponiveis.dart';
import 'package:prototipo/widgets/drawer_adm_custom.dart';

class AdminSecundarioPage extends StatefulWidget {
  const AdminSecundarioPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminSecundarioPageState createState() => _AdminSecundarioPageState();
}

class _AdminSecundarioPageState extends State<AdminSecundarioPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Função para cadastrar o cliente
  Future<void> _registerClient() async {
    try {
      // Criar o usuário com Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      // Após criar o usuário, adicione o papel (role) ao Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': user.email,
        'name': _nameController.text,
        'role': 'cliente',
      });

      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Cliente cadastrado com sucesso!')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerAdmSecundario(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),     
        title: const Text("CADASTROS ADM SECUNDÁRIO", style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                // Quando o botão for clicado, chama a função _registerClient       
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastrarClientePage()));
                },
                child: const Text("CADASTRAR CLIENTE",style: TextStyle(fontSize: 18, color: Colors.white),
                ),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroVeiculosPage()));
                },
                child: const Text("CADASTRAR VEICULOS",
                style: TextStyle(fontSize: 18, color: Colors.white),
                ),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RelatorioVeiculosPage()));
                },
                child: const Text("RELATORIO DOS VEICULOS",
                style: TextStyle(fontSize: 18, color: Colors.white),
                ),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistsScreen()));
                },
                child: const Text("CHECKLIST CADASTRADOS",
                style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
