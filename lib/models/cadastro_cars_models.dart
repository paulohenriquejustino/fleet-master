// carro_model.dart
class Carro {
  final String modelo;
  final String placa;
  final String email;
  final String cidade;
  final String estado;
  final String status;

  Carro({
    required this.modelo,
    required this.placa,
    required this.estado,
    required this.cidade,
    required this.email,
    required this.status,
  });

  // Método para converter o Carro para um Map (necessário para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'placa': placa,
      'criado': DateTime.now(),
      'estado': estado,
      'email': email,
      'cidade': cidade,
      'status': status,
    };
  }
}
