// carro_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototipo/models/cadastro_caminhao_models.dart';



class CaminhaoService {
  final CollectionReference _caminhaoCollection =
      FirebaseFirestore.instance.collection('cadastro_caminhao');

  Future<void> salvarCaminhao(Caminhao caminhao) async {
    try {
      await _caminhaoCollection.add(caminhao.toMap());
      print('Veículo salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar veículo: $e');
      throw Exception('Erro ao salvar veículo');
    }
  }
}
