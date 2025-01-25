import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/tarefa_model.dart';

class TarefaService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retorna a referência para a subcoleção de tarefas do usuário logado
  CollectionReference _getUserTasksCollection() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Usuário não logado");
    }
    return _firestore.collection('usuarios').doc(userId).collection('tarefas');
  }

  // Retorna a lista de tarefas do usuário logado
  Stream<List<Tarefa>> getTarefas() {
    return _getUserTasksCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // Conversão explícita
        return Tarefa.fromMap(doc.id, data);
      }).toList();
    });
  }

  // Adiciona uma tarefa à lista do usuário logado
  Future<void> adicionarTarefa(Tarefa tarefa) async {
    await _getUserTasksCollection().doc(tarefa.id).set(tarefa.toMap());
  }

  // Atualiza uma tarefa existente
  Future<void> editarTarefa(Tarefa tarefa) async {
    await _getUserTasksCollection().doc(tarefa.id).update(tarefa.toMap());
  }

  // Remove uma tarefa da lista do usuário logado
  Future<void> removerTarefa(String id) async {
    await _getUserTasksCollection().doc(id).delete();
  }

  // Alterna o status de conclusão da tarefa
  Future<void> alternarConclusao(String id, bool concluida) async {
    await _getUserTasksCollection().doc(id).update({'concluida': concluida});
  }
}