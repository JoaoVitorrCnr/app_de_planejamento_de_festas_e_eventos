import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_de_planejamento_de_festas_e_eventos/Models/convidado_model.dart';

class ConvidadoService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retorna a referência para a subcoleção de convidados do usuário logado
  CollectionReference _getUserGuestsCollection() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Usuário não logado");
    }
    return _firestore.collection('usuarios').doc(userId).collection('convidados');
  }

  // Retorna a lista de convidados do usuário logado
  Stream<List<Guest>> getGuests() {
    return _getUserGuestsCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Guest.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Adiciona um convidado à lista do usuário logado
  Future<void> addGuest({
    required String name,
    required String email,
    required String statusPresenca,
  }) async {
    await _getUserGuestsCollection().add({
      'name': name,
      'email': email,
      'statusPresenca': statusPresenca,
    });
  }

  // Atualiza os dados de um convidado
  Future<void> updateGuest(
    String guestId, {
    required String name,
    required String email,
  }) async {
    await _getUserGuestsCollection().doc(guestId).update({
      'name': name,
      'email': email,
    });
  }

  // Atualiza o status de presença de um convidado
  Future<void> updatePresenceStatus(String guestId, String statusPresenca) async {
    await _getUserGuestsCollection().doc(guestId).update({
      'statusPresenca': statusPresenca,
    });
  }

  // Remove um convidado da lista do usuário logado
  Future<void> deleteGuest(String guestId) async {
    await _getUserGuestsCollection().doc(guestId).delete();
  }
}