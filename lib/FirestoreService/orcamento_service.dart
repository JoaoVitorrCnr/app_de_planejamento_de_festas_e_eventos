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

  // Verifica e cria o banco de dados inicial, se necessário
  Future<void> _verificarECriarBanco() async {
    String? userId = getUserId();
    if (userId == null) throw Exception("Usuário não logado");

    DocumentSnapshot userDoc =
        await _firestore.collection('usuarios').doc(userId).get();
    if (!userDoc.exists) {
      print("Banco de dados não existe. Criando banco inicial...");
      await _firestore.collection('usuarios').doc(userId).set({
        'despesas': {
          'Decoração': 0.0,
          'Buffet': 0.0,
          'Entretenimento': 0.0,
          'Outros': 0.0,
        },
      });
      print("Banco de dados criado com sucesso.");
    } else {
      print("Banco de dados já existe.");
      // Converte o data() para Map<String, dynamic>
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      // Verifica se o campo 'despesas' existe
      if (data == null || !data.containsKey('despesas')) {
        print("Campo 'despesas' não existe. Criando campo...");
        await _firestore.collection('usuarios').doc(userId).update({
          'despesas': {
            'Decoração': 0.0,
            'Buffet': 0.0,
            'Entretenimento': 0.0,
            'Outros': 0.0,
          },
        });
        print("Campo 'despesas' criado com sucesso.");
      }
    }
  }

  // Salvar ou atualizar uma despesa no Firestore
  Future<void> salvarDespesa(String categoria, double valor) async {
    await _verificarECriarBanco(); // Garante que o banco de dados existe
    String? userId = getUserId();
    if (userId == null) throw Exception("Usuário não logado");

    await _firestore.collection('usuarios').doc(userId).update({
      'despesas.$categoria': valor,
    });
  }

  Future<List<Despesa>> carregarDespesas() async {
    await _verificarECriarBanco(); // Garante que o banco de dados existe
    String? userId = getUserId();
    if (userId == null) throw Exception("Usuário não logado");

    DocumentSnapshot snapshot =
        await _firestore.collection('usuarios').doc(userId).get();
    if (!snapshot.exists) {
      print("Documento do usuário não existe.");
      return [];
    }

    // Converte o data() para Map<String, dynamic>
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    // Verifica se o campo 'despesas' existe
    if (data == null || !data.containsKey('despesas')) {
      print("Campo 'despesas' não existe. Criando campo...");
      await _firestore.collection('usuarios').doc(userId).update({
        'despesas': {
          'Decoração': 0.0,
          'Buffet': 0.0,
          'Entretenimento': 0.0,
          'Outros': 0.0,
        },
      });
      print("Campo 'despesas' criado com sucesso.");
    }

    // Carrega as despesas
    Map<String, dynamic> despesasMap = data!['despesas'];
    print("Dados carregados: $despesasMap");

    return despesasMap.entries.map((entry) {
      return Despesa(
        categoria: entry.key,
        valor: entry.value,
      );
    }).toList();
  }
}
