// carro_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/cadastro_cars_models.dart';


class CarroService {
  final CollectionReference _carroCollection =
      FirebaseFirestore.instance.collection('cadastro_carros');

  Future<void> salvarCarro(Carro carro) async {
    try {
      await _carroCollection.add(carro.toMap());
      print('Veículo salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar veículo: $e');
      throw Exception('Erro ao salvar veículo');
    }
  }
}
