import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/pages/login.dart';

class DrawerAdmSecundario extends StatefulWidget {
  const DrawerAdmSecundario({super.key});

  @override
  State<DrawerAdmSecundario> createState() => _DrawerAdmSecundarioState();
}

class _DrawerAdmSecundarioState extends State<DrawerAdmSecundario> {

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
            accountName: const Text("Administrador Secundário"),
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
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.deepOrange),
            title: const Text('Dashboard'),
            onTap: () {
              // Navegação para a página de Dashboard
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepOrange),
            title: const Text('Perfil'),
            onTap: () {
              // Navegação para a página de Perfil
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.deepOrange),
            title: const Text('Configurações'),
            onTap: () {
              // Navegação para a página de Configurações
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.deepOrange),
            title: const Text('Ajuda'),
            onTap: () {
              // Navegação para a página de Ajuda
              Navigator.pushNamed(context, '/help');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.deepOrange),
            title: const Text('Logout'),
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
