import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para salvar um fornecedor no Firestore
  Future<void> saveSupplier(String name, String phone, String service) async {
    try {
      await _firestore.collection('Fornecedor').add({
        'name': name,
        'phone': phone,
        'service': service,
      });
      print("Fornecedor salvo com sucesso!");
    } catch (e) {
      print("Erro ao salvar fornecedor: $e");
    }
  }
}