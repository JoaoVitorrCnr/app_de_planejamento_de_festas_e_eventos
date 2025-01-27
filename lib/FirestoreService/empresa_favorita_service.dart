import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmpresaFavoritaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtém o UID do usuário logado
  String get uid => _auth.currentUser!.uid;

  // Busca todas as empresas favoritadas do usuário logado
  Stream<QuerySnapshot> obterEmpresasFavoritadas() {
    return _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('favoritados')
        .snapshots();
  }
   Future<bool> verificarExistenciaDaEmpresa(String fornecedorId, String empresaId) async {
    try {
      DocumentSnapshot empresaDoc = await _firestore
          .collection('fornecedores')
          .doc(fornecedorId)
          .collection('empresas')
          .doc(empresaId)
          .get();
      return empresaDoc.exists;
    } catch (e) {
      print("Erro ao verificar existência da empresa: $e");
      return false;
    }
  }

  // Busca todas as empresas favoritadas do usuário logad


  // Adiciona uma empresa aos favoritos do usuário
  Future<void> adicionarAosFavoritos({
    required String empresaId,
    required String fornecedorId,
    required String nome,
    required String resumo,
    required double avaliacao,
    required int quantidadeAvaliacoes,
  }) async {
    await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('favoritados')
        .doc(empresaId)
        .set({
      'empresaId': empresaId,
      'fornecedorId': fornecedorId,
      'nome': nome,
      'resumo': resumo,
      'avaliacao': avaliacao,
      'quantidade_avaliacoes': quantidadeAvaliacoes,
      'data_avaliacao': null, // Inicialmente, não há data de avaliação
    });
  }

  // Remove uma empresa dos favoritos do usuário
  Future<void> removerDosFavoritos(String empresaId) async {
    await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('favoritados')
        .doc(empresaId)
        .delete();
  }

  // Verifica se uma empresa está favoritada pelo usuário
  Future<bool> verificarSeFavoritada(String empresaId) async {
    DocumentSnapshot doc = await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('favoritados')
        .doc(empresaId)
        .get();
    return doc.exists;
  }

  // Obtém a data da última avaliação feita pelo usuário
  Future<DateTime?> obterDataUltimaAvaliacao(String empresaId) async {
    DocumentSnapshot doc = await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('favoritados')
        .doc(empresaId)
        .get();
    if (doc.exists) {
      Timestamp? timestamp = doc['data_avaliacao'] as Timestamp?;
      return timestamp?.toDate();
    }
    return null;
  }

  Future<void> avaliarEmpresa({
    required String empresaId,
    required double novaNota,
    required String fornecedorId,
  }) async {
    // Verifica se os IDs estão vazios
    if (empresaId.isEmpty || fornecedorId.isEmpty) {
      throw Exception("ID da empresa ou fornecedor inválido.");
    }

    // Referência para o documento da empresa no fornecedor
    DocumentReference empresaRef = _firestore
        .collection('fornecedores')
        .doc(fornecedorId)
        .collection('empresas')
        .doc(empresaId);

    // Verifica se o documento da empresa existe
    DocumentSnapshot empresaDoc = await empresaRef.get();
    if (!empresaDoc.exists) {
      throw Exception("Empresa não encontrada no fornecedor especificado.");
    }

    // Obtém a data da última avaliação do usuário para essa empresa (na coleção de favoritos)
    DateTime? dataUltimaAvaliacao = await obterDataUltimaAvaliacao(empresaId);

    // Verifica se o tempo desde a última avaliação é suficiente
    if (dataUltimaAvaliacao != null) {
      DateTime agora = DateTime.now();
      Duration diferenca = agora.difference(dataUltimaAvaliacao);

      // Define o tempo mínimo entre avaliações (exemplo: 2 dias)
      Duration tempoMinimoEntreAvaliacoes = Duration(days: 2);

      if (diferenca < tempoMinimoEntreAvaliacoes) {
        throw Exception(
            "Você só pode avaliar esta empresa uma vez a cada ${tempoMinimoEntreAvaliacoes.inDays} dias.");
      }
    }

    // Captura a data atual antes de salvar
    DateTime dataAtual = DateTime.now();

    // Atualiza a avaliação na coleção de fornecedores (sem alterar a data de avaliação)
    double avaliacaoAtual = empresaDoc['avaliacao'] ?? 0.0; // Valor padrão
    int quantidadeAvaliacoes =
        empresaDoc['quantidade_avaliacoes'] ?? 0; // Valor padrão

    // Calcula a nova avaliação
    double novaAvaliacao = (avaliacaoAtual * quantidadeAvaliacoes + novaNota) /
        (quantidadeAvaliacoes + 1);

    // Atualiza o documento da empresa no fornecedor (sem alterar a data de avaliação)
    await empresaRef.update({
      'avaliacao': novaAvaliacao,
      'quantidade_avaliacoes': quantidadeAvaliacoes + 1,
      // A data de avaliação no fornecedor permanece null
    });

    // Atualiza a avaliação na coleção de favoritos do usuário
    await _atualizarAvaliacaoNosFavoritos(
      empresaId: empresaId,
      fornecedorId: fornecedorId,
      nome: empresaDoc['nome'],
      resumo: empresaDoc['resumo'],
      novaAvaliacao: novaAvaliacao,
      quantidadeAvaliacoes: quantidadeAvaliacoes + 1,
      dataAtual: dataAtual, // Passa a data atual
    );
  }

  // Atualiza a avaliação na coleção de favoritos do usuário
  Future<void> _atualizarAvaliacaoNosFavoritos({
    required String empresaId,
    required String fornecedorId,
    required String nome,
    required String resumo,
    required double novaAvaliacao,
    required int quantidadeAvaliacoes,
    required DateTime dataAtual,
  }) async {
    // Referência para o documento da empresa nos favoritos do usuário
    DocumentReference favoritoRef = _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('favoritados')
        .doc(empresaId);

    // Verifica se o documento da empresa favoritada existe
    DocumentSnapshot favoritoDoc = await favoritoRef.get();

    if (!favoritoDoc.exists) {
      // Se a empresa não está favoritada, adiciona aos favoritos
      await favoritoRef.set({
        'empresaId': empresaId,
        'fornecedorId': fornecedorId,
        'nome': nome,
        'resumo': resumo,
        'avaliacao': novaAvaliacao,
        'quantidade_avaliacoes': quantidadeAvaliacoes,
        'data_avaliacao': Timestamp.fromDate(dataAtual), // Usa a data atual
      });
    } else {
      // Se a empresa já está favoritada, atualiza a avaliação
      await favoritoRef.update({
        'avaliacao': novaAvaliacao,
        'quantidade_avaliacoes': quantidadeAvaliacoes,
        'data_avaliacao': Timestamp.fromDate(dataAtual), // Usa a data atual
      });
    }
  }
}