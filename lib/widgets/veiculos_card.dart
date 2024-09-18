// lib/veiculos_disponivel_card.dart

import 'package:flutter/material.dart';

class VeiculosDisponivelCard extends StatelessWidget {
  final Map<String, dynamic> veiculo;

  const VeiculosDisponivelCard({super.key, required this.veiculo});

  @override
  Widget build(BuildContext context) {
    // Extrai os dados do veículo do parâmetro recebido
    String ano = veiculo['ano'] ?? 'N/A';
    String descricao = veiculo['descricao'] ?? 'N/A';
    String estado = veiculo['estado'] ?? 'N/A';
    String modelo = veiculo['modelo'] ?? 'N/A';
    String placa = veiculo['placa'] ?? 'N/A';
    String proprietario = veiculo['proprietario'] ?? 'N/A';
    String imageUrl = veiculo['imagem'] ?? ''; // Campo da URL da imagem, se existir

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Modelo: $modelo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text('Ano: $ano'),
            Text('Placa: $placa'),
            Text('Estado: $estado'),
            Text('Descrição: $descricao'),
            Text('Proprietário: $proprietario'),
            const SizedBox(height: 10),
            Text(
              'Criado em: ${veiculo['created_at'] ?? 'N/A'}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
