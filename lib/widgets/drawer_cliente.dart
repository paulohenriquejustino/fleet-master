import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/pages/login.dart';

class DrawerCliente extends StatefulWidget {
  const DrawerCliente({super.key});

  @override
  State<DrawerCliente> createState() => _DrawerClienteState();
}

class _DrawerClienteState extends State<DrawerCliente> {
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
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Cliente"),
            accountEmail: Text(userName ?? 'Carregando...'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo.png"),
              backgroundColor: Colors.white,
            ),
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.deepOrange),
            title: const Text('Checklist'),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepOrange),
            title: const Text('Perfil'),
            onTap: () {
             
             
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.deepOrange),
            title: const Text('Configurações'),
            onTap: () {
           
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.deepOrange),
            title: const Text('Ajuda'),
            onTap: () {
              
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.deepOrange),
            title: const Text('Logout', style: TextStyle(),
            ),
            onTap: () {
              // Ação de logout e redirecionamento para a tela de login
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
