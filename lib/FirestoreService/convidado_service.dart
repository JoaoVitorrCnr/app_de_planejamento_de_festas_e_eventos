import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_de_planejamento_de_festas_e_eventos/Models/convidado_model.dart';

class ConvidadoService {
  final CollectionReference _guestsCollection =
      FirebaseFirestore.instance.collection('guests');

  Stream<List<Guest>> getGuests() {
    return _guestsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Guest.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addGuest({
    required String name,
    required String email,
    required String statusPresenca, // Novo campo
  }) async {
    await _guestsCollection.add({
      'name': name,
      'email': email,
      'statusPresenca': statusPresenca,
    });
  }

  Future<void> updateGuest(
    String guestId, {
    required String name,
    required String email,
  }) async {
    await _guestsCollection.doc(guestId).update({
      'name': name,
      'email': email,
    });
  }

  // Método para atualizar o status de presença
  Future<void> updatePresenceStatus(String guestId, String statusPresenca) async {
    await _guestsCollection.doc(guestId).update({
      'statusPresenca': statusPresenca,
    });
  }

  Future<void> deleteGuest(String guestId) async {
    await _guestsCollection.doc(guestId).delete();
  }
}