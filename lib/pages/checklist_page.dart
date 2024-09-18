import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/pages/checklists/checklist_caminhao.dart';
import 'package:prototipo/pages/checklists/checklist_carros.dart';
import 'package:prototipo/pages/checklists/checklist_onibus.dart';
import 'package:prototipo/pages/checklists/checklist_van.dart';

class CheckListPage extends StatefulWidget {
  const CheckListPage({super.key});

  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  List<String> _allowedVehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchUserPermissions();
  }

  Future<void> _fetchUserPermissions() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email!;
      
      // Lista de coleções de veículos
      List<String> vehicleCollections = [
        'cadastro_carros',
        'cadastro_van',
        'cadastro_onibus',
        'cadastro_caminhao',
      ];

      for (String collection in vehicleCollections) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(collection)
            .where('email', isEqualTo: userEmail)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Se o email for encontrado na coleção, adicionar o veículo correspondente
          setState(() {
            if (collection == 'cadastro_carros') {
              _allowedVehicles.add('Carro');
            } else if (collection == 'cadastro_van') {
              _allowedVehicles.add('Van');
            } else if (collection == 'cadastro_onibus') {
              _allowedVehicles.add('Ônibus');
            } else if (collection == 'cadastro_caminhao') {
              _allowedVehicles.add('Caminhão');
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check List Veículos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: _buildVehicleButtons(context),
        ),
      ),
    );
  }

  List<Widget> _buildVehicleButtons(BuildContext context) {
    List<Widget> buttons = [];

    // Exibir o checklist de acordo com os veículos permitidos
    if (_allowedVehicles.contains('Carro')) {
      buttons.add(_buildButton(
        context,
        'Check List Carros',
        Icons.directions_car,
        Colors.blue,
        const ChecklistCarrosScreen(),
      ));
    }

    if (_allowedVehicles.contains('Van')) {
      buttons.add(_buildButton(
        context,
        'Check List Van',
        Icons.directions_bus,
        Colors.green,
        const ChecklistVanScreen(),
      ));
    }

    if (_allowedVehicles.contains('Ônibus')) {
      buttons.add(_buildButton(
        context,
        'Check List Ônibus',
        Icons.airport_shuttle,
        Colors.orange,
        const ChecklistOnibusScreen(),
      ));
    }

    if (_allowedVehicles.contains('Caminhão')) {
      buttons.add(_buildButton(
        context,
        'Check List Caminhão',
        Icons.local_shipping,
        Colors.red,
        const ChecklistCaminhaoScreen(),
      ));
    }

    return buttons;
  }

  Widget _buildButton(BuildContext context, String label, IconData icon,
      Color color, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
