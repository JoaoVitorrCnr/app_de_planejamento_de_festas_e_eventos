import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/despesa_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrcamentoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna o ID do usuário logado
  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  // Cria o banco de dados inicial caso não exista
  Future<void> criarBancoInicial() async {
    String? userId = getUserId();
    if (userId == null) throw Exception("Usuário não logado");

    // Verifica se a coleção já existe
    DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(userId).get();
    if (!userDoc.exists) {
      // Cria a coleção inicial com as categorias padrão
      await _firestore.collection('usuarios').doc(userId).set({
        'despesas': {
          'Decoração': 0.0,
          'Buffet': 0.0,
          'Entretenimento': 0.0,
          'Outros': 0.0,
        },
      });
    }
  }

  // Salvar ou atualizar uma despesa no Firestore
  Future<void> salvarDespesa(String categoria, double valor) async {
    String? userId = getUserId();
    if (userId == null) throw Exception("Usuário não logado");

    await _firestore.collection('usuarios').doc(userId).update({
      'despesas.$categoria': valor,
    });
  }

  // Carregar todas as despesas do Firestore
  Future<List<Despesa>> carregarDespesas() async {
    String? userId = getUserId();
    if (userId == null) throw Exception("Usuário não logado");

    DocumentSnapshot snapshot = await _firestore.collection('usuarios').doc(userId).get();
    if (!snapshot.exists) {
      await criarBancoInicial(); // Cria o banco inicial se não existir
      return [
        Despesa(categoria: 'Decoração', valor: 0.0),
        Despesa(categoria: 'Buffet', valor: 0.0),
        Despesa(categoria: 'Entretenimento', valor: 0.0),
        Despesa(categoria: 'Outros', valor: 0.0),
      ];
    }

    Map<String, dynamic> despesasMap = snapshot['despesas'];
    return despesasMap.entries.map((entry) {
      return Despesa(
        categoria: entry.key,
        valor: entry.value,
      );
    }).toList();
  }
}