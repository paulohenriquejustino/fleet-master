import 'package:flutter/material.dart';

class KmInputCard extends StatelessWidget {
  final TextEditingController kmInicioController;
  final TextEditingController kmUltimaTrocaController;
  final TextEditingController kmProximaTrocaController;

  const KmInputCard({
    required this.kmInicioController,
    required this.kmUltimaTrocaController,
    required this.kmProximaTrocaController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 206, 205, 205),
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
            TextField(
              controller: kmInicioController,
              decoration: const InputDecoration(
                hintText: 'Km de início',
                labelText: 'Km de início',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: kmUltimaTrocaController,
              decoration: const InputDecoration(
                labelText: 'Km da última troca de óleo',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: kmProximaTrocaController,
              decoration: const InputDecoration(
                labelText: 'Km da próxima troca de óleo',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
