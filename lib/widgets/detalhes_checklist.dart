import 'package:flutter/material.dart';

class DetalhesChecklist extends StatelessWidget {
  final Map<String, dynamic> checklist;

  DetalhesChecklist({required this.checklist});

  @override
  Widget build(BuildContext context) {
    // Extrair os itens do checklist
    final items = checklist['items'] ?? {}; // Supondo que 'items' seja o mapa dos itens

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Checklist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibir informações básicas do checklist
            Text('Tipo de Veículo: ${checklist['tipo_veiculo']}'),
            Text('Placa: ${checklist['placa']}'),
            Text('Modelo: ${checklist['modelo']}'),
            Text('Email: ${checklist['email']}'),
            Text('Data: ${checklist['data_checklist']}'),
            Text('Cidade: ${checklist['cidade']}'),
            const SizedBox(height: 20),
            // Título da seção de itens
            const Text('Itens do Checklist:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  // Acessa os dados do item
                  final itemKey = 'item_$index'; // Baseado na estrutura mostrada
                  final item = items[itemKey] ?? {};

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(item['title'] ?? 'Sem título'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descrição: ${item['description'] ?? 'Sem descrição'}'),
                          Text('Status: ${item['checked'] ?? 'Não especificado'}'),
                          if (item['comentario'] != null && item['comentario'].isNotEmpty)
                            Text('Comentário: ${item['comentario']}'),
                          if (item['naoConformidadeDescricao'] != null &&
                              item['naoConformidadeDescricao'].isNotEmpty)
                            Text('Não conformidade: ${item['naoConformidadeDescricao']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
