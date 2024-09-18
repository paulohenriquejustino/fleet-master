// carro_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototipo/models/cadastro_onibus_models.dart';

class OnibusService {
  final CollectionReference _carroCollection = FirebaseFirestore.instance.collection('cadastro_onibus');

  Future<void> salvarOnibus(Onibus onibus) async {
    try {
      await _carroCollection.add(onibus.toMap());
      print('Veículo salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar veículo: $e');
      throw Exception('Erro ao salvar veículo');
    }
  }
}
