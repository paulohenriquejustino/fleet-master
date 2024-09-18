// lib/veiculos_disponiveis_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class RelatorioVeiculosPage extends StatefulWidget {
  const RelatorioVeiculosPage({super.key});

  @override
  State<RelatorioVeiculosPage> createState() => _RelatorioVeiculosPageState();
}

class _RelatorioVeiculosPageState extends State<RelatorioVeiculosPage> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 abas para cada tipo de veículo
  }

  // Método para combinar múltiplos streams de coleções diferentes
  Stream<Map<String, Map<String, List<Map<String, dynamic>>>>> streamVeiculos() {
    final caminhaoStream = _firestore.collection('cadastro_caminhao').snapshots();
    final carrosStream = _firestore.collection('cadastro_carros').snapshots();
    final onibusStream = _firestore.collection('cadastro_onibus').snapshots();
    final vanStream = _firestore.collection('cadastro_van').snapshots();

    return Rx.combineLatest4(
      caminhaoStream,
      carrosStream,
      onibusStream,
      vanStream,
      (QuerySnapshot caminhaoSnapshot, QuerySnapshot carrosSnapshot, QuerySnapshot onibusSnapshot, QuerySnapshot vanSnapshot) {
        Map<String, Map<String, List<Map<String, dynamic>>>> veiculosMap = {
          'caminhao': {'disponiveis': [], 'indisponiveis': []},
          'carros': {'disponiveis': [], 'indisponiveis': []},
          'onibus': {'disponiveis': [], 'indisponiveis': []},
          'van': {'disponiveis': [], 'indisponiveis': []},
        };

        // Caminhão
        for (var doc in caminhaoSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['status'] == 'disponivel') {
            veiculosMap['caminhao']!['disponiveis']!.add(data);
          } else {
            veiculosMap['caminhao']!['indisponiveis']!.add(data);
          }
        }

        // Carros
        for (var doc in carrosSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['status'] == 'disponivel') {
            veiculosMap['carros']!['disponiveis']!.add(data);
          } else {
            veiculosMap['carros']!['indisponiveis']!.add(data);
          }
        }

        // Ônibus
        for (var doc in onibusSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['status'] == 'disponivel') {
            veiculosMap['onibus']!['disponiveis']!.add(data);
          } else {
            veiculosMap['onibus']!['indisponiveis']!.add(data);
          }
        }

        // Vans
        for (var doc in vanSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['status'] == 'disponivel') {
            veiculosMap['van']!['disponiveis']!.add(data);
          } else {
            veiculosMap['van']!['indisponiveis']!.add(data);
          }
        }

        return veiculosMap;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Caminhão'),
            Tab(text: 'Carros'),
            Tab(text: 'Ônibus'),
            Tab(text: 'Van'),
          ],
        ),
      ),
      body: StreamBuilder<Map<String, Map<String, List<Map<String, dynamic>>>>>(
        stream: streamVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum veículo encontrado.'));
          }

          final veiculos = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildVeiculosTab('Caminhão', veiculos['caminhao']!),
              _buildVeiculosTab('Carros', veiculos['carros']!),
              _buildVeiculosTab('Ônibus', veiculos['onibus']!),
              _buildVeiculosTab('Van', veiculos['van']!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVeiculosTab(String tipo, Map<String, List<Map<String, dynamic>>> veiculos) {
    final veiculosDisponiveis = veiculos['disponiveis']!;
    final veiculosIndisponiveis = veiculos['indisponiveis']!;

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Disponíveis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...veiculosDisponiveis.map((veiculo) => _buildVeiculoCard(veiculo)).toList(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Indisponíveis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...veiculosIndisponiveis.map((veiculo) => _buildVeiculoCard(veiculo)).toList(),
      ],
    );
  }

  Widget _buildVeiculoCard(Map<String, dynamic> veiculo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(veiculo['modelo'] ?? 'Modelo desconhecido'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Placa: ${veiculo['placa'] ?? 'N/A'}'),
            Text('Cidade: ${veiculo['cidade'] ?? 'N/A'}'),
            Text('Status: ${veiculo['status'] ?? 'N/A'}'),
            Text('Criado: ${veiculo['criado em'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
