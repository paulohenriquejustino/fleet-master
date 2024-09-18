import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/widgets/detalhes_checklist.dart';

class ChecklistsScreen extends StatefulWidget {
  @override
  _ChecklistsScreenState createState() => _ChecklistsScreenState();
}

class _ChecklistsScreenState extends State<ChecklistsScreen> {
  Future<List<Map<String, dynamic>>>? _checklistsFuture;
  String _selectedVehicleType = 'Todos'; // Valor inicial

  @override
  void initState() {
    super.initState();
    _checklistsFuture = fetchAllChecklists();
  }

  // Função para filtrar os checklists
  Future<List<Map<String, dynamic>>> fetchAllChecklists(
      [String? tipoVeiculo]) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Coleta os checklists de cada tipo de veículo
    List<Map<String, dynamic>> allChecklists = [];

    // Definindo as coleções a serem consultadas
    List<String> checklistCollections = [
      'checklist_carros',
      'checklist_caminhao',
      'checklist_van',
      'checklist_onibus'
    ];

    for (String collection in checklistCollections) {
      // Se o tipo de veículo foi selecionado, faz o filtro
      if (tipoVeiculo != null &&
          tipoVeiculo != 'Todos' &&
          !collection.contains(tipoVeiculo)) {
        continue; // Ignora as coleções que não correspondem ao filtro
      }

      QuerySnapshot querySnapshot =
          await firestore.collection(collection).get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id; // Adiciona o ID do documento ao resultado
        data['tipo_veiculo'] =
            collection.replaceAll('checklist_', ''); // Adiciona tipo
        allChecklists.add(data);
      }
    }

    return allChecklists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKLISTS DISPONIVEIS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // DropdownButton para filtrar por tipo de veículo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedVehicleType,
              items: <String>['Todos', 'carros', 'caminhao', 'van', 'onibus']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedVehicleType = newValue!;
                  // Atualiza o Future para buscar o checklist filtrado
                  _checklistsFuture = fetchAllChecklists(_selectedVehicleType);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _checklistsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar checklists'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum checklist encontrado'));
                }

                final checklists = snapshot.data!;

                return ListView.builder(
                  itemCount: checklists.length,
                  itemBuilder: (context, index) {
                    final checklist = checklists[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            '${checklist['tipo_veiculo']} - Placa: ${checklist['placa']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Placa: ${checklist['placa']}'),
                            Text('Modelo: ${checklist['modelo']}'),
                            Text('Email: ${checklist['email']}'),
                            Text('Data: ${checklist['data_checklist']}'),
                            Text('Cidade: ${checklist['cidade']}'),
                            Text('Km Início: ${checklist['km_inicio']}'),
                            Text(
                                'Km Próxima Troca: ${checklist['km_proxima_troca']}'),
                            Text(
                                'Km Última Troca: ${checklist['km_ultima_troca']}'),
                          ],
                        ),
                        onTap: () {
                          // Navega para a tela de detalhes com os dados do checklist
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalhesChecklist(
                                checklist: checklist, // Passa o checklist selecionado
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
