import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/pages/checklist_page.dart';
import 'package:prototipo/pages/login.dart';
import 'package:prototipo/widgets/drawer_cliente.dart';
class ClienteOpcaoPage extends StatefulWidget {
  const ClienteOpcaoPage({super.key});

  @override
  State<ClienteOpcaoPage> createState() => _ClienteOpcaoPageState();
}

class _ClienteOpcaoPageState extends State<ClienteOpcaoPage> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? user?.email ?? 'Usuário';
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerCliente(),
      appBar: AppBar(
        title: Text(userName ?? 'Carregando...', style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
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
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckListPage()),
                );
              },
              child: const Text('CHECKLIST DE VEÍCULOS', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            
          ],
        ),
      ),
    );
  }
}
