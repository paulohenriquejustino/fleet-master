import 'package:flutter/material.dart';
import 'package:prototipo/pages/cadastro/caminhao_cadastro.dart';
import 'package:prototipo/pages/cadastro/carro_cadastro.dart';
import 'package:prototipo/pages/cadastro/onibus_cadastro.dart';
import 'package:prototipo/pages/cadastro/van_cadastro.dart';

class CadastroVeiculosPage extends StatefulWidget {
  const CadastroVeiculosPage({super.key});

  @override
  State<CadastroVeiculosPage> createState() => _CadastroVeiculosPageState();
}

class _CadastroVeiculosPageState extends State<CadastroVeiculosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRAR VEÍCULOS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0
          )
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute( builder: (context) => const CarroCadastroPage()));
              },
              child: const Text('CADASTRAR CARROS', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
                  
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const CaminhaoCadastroPage()));
              },
              child: const Text('CADASTRAR CAMINHÃO', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const OnibusCadastroPage()));
              },
              child: const Text('CADASTRAR ONIBUS', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(300, 50),
              ),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => const VanCadastroPage()));
              },
              child: const Text('CADASTRAR VAN', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
      
              ),
            ),
          ],
        ),
      ),
    );
  }
}
