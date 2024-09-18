// Caminhao_model.dart
class Caminhao {
  final String modelo;
  final String placa;
  final String estado;
  final String cidade;
  final String email;
  final String status;

  Caminhao({
    required this.modelo,
    required this.placa,
    required this.estado,
    required this.cidade,
    required this.status, 
    required this.email
  });

  // Método para converter o Caminhao para um Map (necessário para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'placa': placa,
      'criado em': DateTime.now(),
      'estado': estado,
      'cidade': cidade,
      'status': status,
      'email': email
    };
  }
}
