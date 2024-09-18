// carro_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototipo/models/cadastro_van_models.dart';

class VanService {
  final CollectionReference _vanCollection =
      FirebaseFirestore.instance.collection('cadastro_van');

  Future<void> salvarVan(Van van) async {
    try {
      await _vanCollection.add(van.toMap());
      print('Veículo salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar veículo: $e');
      throw Exception('Erro ao salvar veículo');
    }
  }
}
