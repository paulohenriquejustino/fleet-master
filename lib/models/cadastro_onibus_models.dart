// Onibus_model.dart
class Onibus {
  final String modelo;
  final String placa;
  final String estado;
  final String cidade;
  final String status;
  final String email;

  Onibus({
    required this.modelo,
    required this.placa,
    required this.email,
    required this.estado,
    required this.cidade,
    required this.status,
  });

  // Método para converter o Onibus para um Map (necessário para salvar no Firestore)
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
