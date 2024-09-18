import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistCarrosScreen extends StatefulWidget {
  const ChecklistCarrosScreen({super.key});

  @override
  State<ChecklistCarrosScreen> createState() => _ChecklistCarrosScreenState();
}

class _ChecklistCarrosScreenState extends State<ChecklistCarrosScreen> {
  final TextEditingController kmInicioController = TextEditingController();
  final TextEditingController kmUltimaTrocaController = TextEditingController();
  final TextEditingController kmProximaTrocaController =
      TextEditingController();

  List<ItemChecklist> items = [
    ItemChecklist('Lataria', 'Verificar integridade de toda a lataria.'),
    ItemChecklist(
        'Faróis/Lâmpadas/Piscas', 'Verificar condições e funcionamento.'),
    ItemChecklist(
        'Pneus', 'Verificar se estão calibrados e se existe alguma avaria.'),
    ItemChecklist(
        'Para-brisa e limpadores', 'Verificar condições e funcionamento.'),
    ItemChecklist('Retrovisores', 'Verificar condições e funcionamento.'),
    ItemChecklist(
        'Instrumentos e indicadores', 'Verificar no painel os indicadores.'),
    ItemChecklist('Ar-condicionado', 'Verificar condições e funcionamento.'),
    ItemChecklist(
        'Cintos de segurança', 'Verificar condições e funcionamento.'),
    ItemChecklist('Óleo do motor', 'Verificar o nível.'),
    ItemChecklist('Fluido de freio', 'Verificar o nível.'),
    ItemChecklist('Líquido de arrefecimento', 'Verificar o nível.'),
    ItemChecklist('Fluido de direção hidráulica', 'Verificar o nível.'),
    ItemChecklist('Fluido de embreagem', 'Verificar o nível.'),
    ItemChecklist('Bateria', 'Verificar carga e corrosões nos terminais.'),
    ItemChecklist('Freios', 'Verificar condições e funcionamento.'),
    ItemChecklist('Documentação', 'Verificar se os documentos estão em ordem.'),
    ItemChecklist('Itens de segurança', 'Chave de roda/ Triangulo/ Macaco.'),
  ];

  bool showFinalizarButton = false;
  String? selectedPlaca;
  String? selectedModelo;
  String? selectedCidade;
  List<Map<String, String>> placasDisponiveis = [];
  bool isLoadingPlacas = true;

  @override
  void initState() {
    super.initState();
    fetchPlacasDisponiveis();
  }

  Future<void> fetchPlacasDisponiveis() async {
    try {
      // Filtrando apenas veículos disponíveis
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('cadastro_carros')
          .where('status', isEqualTo: 'disponivel')
          .get();

      // Criando uma lista de mapas com as placas disponíveis
      List<Map<String, String>> fetchedplacas = [];

      // Varrendo os documentos retornados.
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Verificação de campos nulos
        String? placa = data['placa'] as String?;
        String? modelo = data['modelo'] as String?;
        String? cidade = data['cidade'] as String?;

        if (placa != null && modelo != null && cidade != null) {
          fetchedplacas
              .add({'placa': placa, 'modelo': modelo, 'cidade': cidade});
        }
      }
      // Atualizando a tela.
      setState(() {
        placasDisponiveis = fetchedplacas;
        isLoadingPlacas = false;
      });

      // Verificando se tem veículos disponíveis.
      if (placasDisponiveis.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhuma placa disponível')),
        );
      }
    } catch (e) {
      // Tratando o erro.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar placas disponíveis: $e')),
      );
    }
  }

  Future<void> finalizarChecklist() async {
    if (selectedPlaca != null) {
      // Verificar se já existe um checklist para essa placa
      bool checklistExiste = await verificarSeChecklistJaExiste(selectedPlaca!);

      if (checklistExiste) {
        // Se já existe, mostrar um alerta para o usuário
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Checklist já foi feito para essa placa!')),
        );
      } else {
        // Se não existe, prosseguir com o envio do checklist
        await addChecklistToFirebase(
          selectedPlaca!,
          selectedModelo!,
          selectedCidade!,
          items,
          kmInicioController.text,
          kmUltimaTrocaController.text,
          kmProximaTrocaController.text,
        );

        await updateCarStatus(selectedPlaca!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checklist enviado com sucesso!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma placa!')),
      );
    }
  }

// Função para verificar se já existe um checklist para a placa no Firestore
  Future<bool> verificarSeChecklistJaExiste(String placa) async {
    try {
      // Buscar documentos na coleção 'checklist_carros' onde a placa é igual à placa selecionada
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('checklist_carros')
          .where('placa', isEqualTo: placa)
          .get();

      // Retorna true se houver ao menos um documento encontrado, indicando que o checklist já foi feito
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // Em caso de erro, exibe uma mensagem e retorna false (como fallback)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar checklist existente: $e')),
      );
      return false;
    }
  }

  double getCompletionPercentage() {
    int filledItems = items.where((item) => item.checked != null).length;
    double percentage = (filledItems / items.length) * 100;

    if (percentage == 100) {
      setState(() {
        showFinalizarButton = true;
      });
    } else {
      setState(() {
        showFinalizarButton = false;
      });
    }

    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist de Veículos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          isLoadingPlacas
              ? const CircularProgressIndicator()
              : DropdownButton<String>(
                  value: selectedPlaca,
                  hint: const Text('SELECIONE UMA PLACA'),
                  items: placasDisponiveis.map((placaInfo) {
                    return DropdownMenuItem<String>(
                      value: placaInfo['placa'],
                      child: Text(
                          '${placaInfo['modelo']} - ${placaInfo['placa']}'),
                      onTap: () {
                        // Captura o modelo do carro quando uma placa é selecionada
                        selectedModelo = placaInfo['modelo'];
                        selectedCidade = placaInfo['cidade'];
                        selectedPlaca = placaInfo['placa'];
                      },
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPlaca = newValue!;
                    });
                  },
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: getCompletionPercentage() / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Progresso: ${getCompletionPercentage().toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return buildKmFieldsCard();
                } else {
                  final itemIndex = index - 1;
                  return buildChecklistItemCard(itemIndex);
                }
              },
            ),
          ),
          if (showFinalizarButton)
            FloatingActionButton.extended(
              onPressed: finalizarChecklist,
              label: const Text('Finalizar'),
              icon: const Icon(Icons.check),
            ),
        ],
      ),
    );
  }

  Widget buildKmFieldsCard() {
    return Card(
      color: Colors.white30,
      margin: const EdgeInsets.all(10.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: kmInicioController,
              decoration: const InputDecoration(
                labelText: 'Km de início',
                labelStyle: TextStyle(color: Colors.black, fontSize: 16),
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: kmUltimaTrocaController,
              decoration: const InputDecoration(
                  labelText: 'Km da última troca de óleo',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: kmProximaTrocaController,
              decoration: const InputDecoration(
                  labelText: 'Km da próxima troca de óleo',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChecklistItemCard(int itemIndex) {
    return Card(
      color: const Color.fromARGB(255, 206, 205, 205),
      margin: const EdgeInsets.all(10.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color:
                  items[itemIndex].checked != null ? Colors.black : Colors.red,
              width: 4.0,
            ),
          ),
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(items[itemIndex].title),
                subtitle: Text(items[itemIndex].description),
              ),
              buildStatusButton(
                  'Conforme', ItemChecklistStatus.conforme, itemIndex),
              buildStatusButton(
                  'Não Conforme', ItemChecklistStatus.naoConforme, itemIndex),
              buildStatusButton(
                  'Inexistente', ItemChecklistStatus.inexistente, itemIndex),
              if (items[itemIndex].checked == ItemChecklistStatus.naoConforme)
                buildNonConformityFields(itemIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatusButton(
      String text, ItemChecklistStatus status, int itemIndex) {
    Color? backgroundColor;

    switch (status) {
      case ItemChecklistStatus.conforme:
        backgroundColor =
            items[itemIndex].checked == ItemChecklistStatus.conforme
                ? Colors.green
                : Colors.grey[300];
        break;
      case ItemChecklistStatus.naoConforme:
        backgroundColor =
            items[itemIndex].checked == ItemChecklistStatus.naoConforme
                ? Colors.red
                : Colors.grey[300];
        break;
      case ItemChecklistStatus.inexistente:
        backgroundColor =
            items[itemIndex].checked == ItemChecklistStatus.inexistente
                ? Colors.orange
                : Colors.grey[300];
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: backgroundColor,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(text),
        onPressed: () {
          setState(() {
            items[itemIndex].checked = status;
          });
        },
      ),
    );
  }

  Widget buildNonConformityFields(int itemIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        TextField(
          decoration:
              const InputDecoration(labelText: 'Descrição da Não Conformidade'),
          onChanged: (value) {
            setState(() {
              items[itemIndex].naoConformidadeDescricao = value;
            });
          },
        ),
      ],
    );
  }
}

class ItemChecklist {
  String title;
  String description;
  ItemChecklistStatus? checked;
  String? comentario;
  String? naoConformidadeDescricao;
  File? image;

  ItemChecklist(this.title, this.description);
}

enum ItemChecklistStatus { conforme, naoConforme, inexistente }

Future<void> addChecklistToFirebase(
  String placa,
  String modelo, // Adicionar o modelo aqui
  String cidade,
  List<ItemChecklist> items,
  String kmInicio,
  String kmUltimaTroca,
  String kmProximaTroca,
) async {
  final checklistCarros =
      FirebaseFirestore.instance.collection('checklist_carros');
  Map<String, dynamic> itemMap = {};

  items.asMap().forEach((index, item) {
    itemMap['item_$index'] = {
      'title': item.title,
      'description': item.description,
      'checked': item.checked.toString(),
      'comentario': item.comentario ?? '',
      'naoConformidadeDescricao': item.naoConformidadeDescricao ?? '',
      'imagePath': item.image?.path ?? '',
    };
  });

  await checklistCarros.add({
    'placa': placa,
    'modelo': modelo,
    'cidade': cidade,
    'km_inicio': kmInicio,
    'km_ultima_troca': kmUltimaTroca,
    'km_proxima_troca': kmProximaTroca,
    'items': itemMap,
    'data_checklist': DateTime.now().toIso8601String(),
  });
}

Future<void> updateCarStatus(String placa) async {
  // Referência à coleção de carros
  final veiculosCollection =
      FirebaseFirestore.instance.collection('cadastro_carros');

  // Procurar o documento pelo campo 'placa'
  QuerySnapshot snapshot =
      await veiculosCollection.where('placa', isEqualTo: placa).get();

  if (snapshot.docs.isNotEmpty) {
    // Se o documento existir, pegar o ID e atualizar
    String documentId = snapshot.docs.first.id;

    await veiculosCollection.doc(documentId).update({
      'status': 'indisponivel',
    });
  } else {
    throw Exception('Documento não encontrado para a placa: $placa');
  }
}
