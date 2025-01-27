import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmpresaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtém o UID do usuário logado
  String get uid => _auth.currentUser!.uid;

  // Adiciona uma nova empresa
  Future<void> adicionarEmpresa({
    required String nome,
    required String resumo,
    required String descricao,
    required String cnpj,
  }) async {
    // Verifica se o CNPJ já existe apenas na coleção do usuário logado
    QuerySnapshot cnpjExistente = await _firestore
        .collection('fornecedores')
        .doc(uid) // UID do usuário logado
        .collection('empresas')
        .where('cnpj', isEqualTo: cnpj) // Filtra pelo campo 'cnpj'
        .get();

    if (cnpjExistente.docs.isNotEmpty) {
      throw Exception("CNPJ já cadastrado.");
    }

    // Adiciona a nova empresa ao Firestore
    await _firestore
        .collection('fornecedores')
        .doc(uid)
        .collection('empresas')
        .add({
      'nome': nome,
      'resumo': resumo,
      'descricao': descricao,
      'cnpj': cnpj,
      'avaliacao': 0.0,
      'quantidade_avaliacoes': 0,
      'data_avaliacao': null, // Adiciona o campo data_avaliacao
      'fornecedorId': uid, // Adiciona o ID do fornecedor logado
    });
  }

  // Exclui uma empresa
  Future<void> excluirEmpresa(String empresaId) async {
    await _firestore
        .collection('fornecedores')
        .doc(uid) // Usa o UID do usuário logado
        .collection('empresas')
        .doc(empresaId)
        .delete();
  }

  // Edita uma empresa
  Future<void> editarEmpresa({
    required String empresaId,
    required String nome,
    required String resumo,
    required String descricao,
    required String cnpj,
  }) async {
    await _firestore
        .collection('fornecedores')
        .doc(uid) // Usa o UID do usuário logado
        .collection('empresas')
        .doc(empresaId)
        .update({
      'nome': nome,
      'resumo': resumo,
      'descricao': descricao,
      'cnpj': cnpj,
    });
  }

  // Obtém a lista de empresas do usuário logado
  Stream<QuerySnapshot> obterEmpresas() {
    return _firestore
        .collection('fornecedores')
        .doc(uid) // Usa o UID do usuário logado
        .collection('empresas')
        .snapshots();
  }

  // Obtém os detalhes de uma empresa específica
  Future<DocumentSnapshot> obterDetalhesEmpresa(String empresaId) async {
    return await _firestore
        .collection('fornecedores')
        .doc(uid) // Usa o UID do usuário logado
        .collection('empresas')
        .doc(empresaId)
        .get();
  }

  // Retorna todas as empresas de todos os fornecedores
  Stream<QuerySnapshot> obterTodasEmpresas() {
    return _firestore.collectionGroup('empresas').snapshots();
  }
}