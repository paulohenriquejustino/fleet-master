import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/models/cadastro_caminhao_models.dart';
import 'package:prototipo/models/cadastro_cars_models.dart';
import 'package:prototipo/service/cadastros/cadastro_caminhao_service.dart';
import 'package:prototipo/service/cadastros/cadastro_cars_service.dart';

class CaminhaoCadastroPage extends StatefulWidget {
  const CaminhaoCadastroPage({super.key});

  @override
  State<CaminhaoCadastroPage> createState() => _CaminhaoCadastroPageState();
}

class _CaminhaoCadastroPageState extends State<CaminhaoCadastroPage> {
  // Chamando o meu service
  final CaminhaoService _caminhaoService = CaminhaoService();
  // Controladores para os campos do formulário
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

   // Função para pegar o email do usuário autenticado
  String? _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email; // Retorna o email se o usuário estiver logado
  }


  // Função para salvar o veículo usando caminhaoService.
  Future<void> _salvarcaminhao() async {
    final Caminhao caminhao = Caminhao(
      modelo: _modeloController.text,
      placa: _placaController.text,
      estado: _estadoController.text,
      cidade: _cidadeController.text,
      email: _emailController.text,
      status: 'disponivel',
    );

    try {
      await _caminhaoService.salvarCaminhao(caminhao);
      // Criando um mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veículo ${caminhao.modelo} salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Limpando os campos apos salvar
      _modeloController.clear();
      _placaController.clear();
      _estadoController.clear();
      _cidadeController.clear();
      _emailController.clear();


    } catch (e) {
      // Criando uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar o veículo: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('CADASTRAR CAMINHOES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0
          )
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo para o modelo
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 16.0),
              // Campo para a placa
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
              ),
              const SizedBox(height: 16.0),
              // Campo para o estado
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _estadoController,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16.0),
              // Campo para a cidade
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16.0),
              // Campo para o email
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email do Usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 32.0),
              // Botão para salvar o veículo
              ElevatedButton(
                onPressed: _salvarcaminhao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'SALVAR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
