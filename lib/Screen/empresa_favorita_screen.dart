import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../FirestoreService/empresa_favorita_service.dart';

class EmpresasFavoritadasScreen extends StatelessWidget {
  final EmpresaFavoritaService _empresaFavoritaService =
      EmpresaFavoritaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Salvar fornecedor",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple, // Cor temática
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _empresaFavoritaService.obterEmpresasFavoritadas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Nenhuma empresa favoritada.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var empresa = snapshot.data!.docs[index];
              var dados = empresa.data() as Map<String, dynamic>;

              // Verifica se os campos necessários estão presentes
              String empresaId = dados['empresaId'] ?? '';
              String fornecedorId = dados['fornecedorId'] ?? '';
              String nome = dados['nome'] ?? 'Nome não disponível';
              String resumo = dados['resumo'] ?? 'Resumo não disponível';
              double avaliacao = dados['avaliacao'] ?? 0.0;
              int quantidadeAvaliacoes = dados['quantidade_avaliacoes'] ?? 0;

              return Card(
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    _mostrarDetalhesEmpresa(context, dados);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          resumo,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              "Avaliação: ${avaliacao.toStringAsFixed(1)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _mostrarDialogoAvaliacao(
                                  context, empresaId, fornecedorId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              "Avaliar",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Mostra os detalhes da empresa em uma nova janela
  void _mostrarDetalhesEmpresa(
      BuildContext context, Map<String, dynamic> dados) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            dados['nome'],
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descrição: ${dados['descricao']}",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Avaliação: ${dados['avaliacao'].toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Quantidade de avaliações: ${dados['quantidade_avaliacoes']}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Fechar",
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoAvaliacao(
      BuildContext context, String empresaId, String fornecedorId) {
    double novaNota = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              title: Text(
                "Avaliar Fornecedor",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Selecione uma nota de 0 a 5:",
                    style: TextStyle(fontSize: 14),
                  ),
                  Slider(
                    value: novaNota,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    onChanged: (value) {
                      setState(() {
                        novaNota = value;
                      });
                    },
                  ),
                  Text(
                    "Nota selecionada: ${novaNota.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _empresaFavoritaService.avaliarEmpresa(
                        empresaId: empresaId,
                        novaNota: novaNota,
                        fornecedorId: fornecedorId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Avaliação enviada com sucesso!")),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}