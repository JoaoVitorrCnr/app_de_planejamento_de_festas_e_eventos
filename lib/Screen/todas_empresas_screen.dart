import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../FirestoreService/empresa_service.dart'; // Importe o serviço de empresas
import '../FirestoreService/empresa_favorita_service.dart'; // Importe o serviço de favoritos
import 'empresa_favorita_screen.dart';

class TodasEmpresasScreen extends StatefulWidget {
  @override
  _TodasEmpresasScreenState createState() => _TodasEmpresasScreenState();
}

class _TodasEmpresasScreenState extends State<TodasEmpresasScreen> {
  final EmpresaService _empresaService = EmpresaService(); // Use o serviço de empresas
  final EmpresaFavoritaService _empresaFavoritaService = EmpresaFavoritaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fornecedores",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple, // Cor temática
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navegar para a tela de empresas favoritadas
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmpresasFavoritadasScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _empresaService.obterTodasEmpresas(), // Chame a função correta
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "Nenhuma empresa cadastrada.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var empresa = snapshot.data!.docs[index];
                var dados = empresa.data() as Map<String, dynamic>;

                // Verifica se os campos necessários estão presentes
                String empresaId = empresa.id;
                String nome = dados['nome'] ?? 'Nome não disponível';
                String resumo = dados['resumo'] ?? 'Resumo não disponível';
                double avaliacao = dados['avaliacao'] ?? 0.0;
                int quantidadeAvaliacoes = dados['quantidade_avaliacoes'] ?? 0;
                String descricao = dados['descricao'] ?? 'Descrição não disponível';

                return Card(
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      nome,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              "Avaliação: ${avaliacao.toStringAsFixed(1)} ($quantidadeAvaliacoes avaliações)",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: FutureBuilder<bool>(
                      future: _empresaFavoritaService.verificarSeFavoritada(empresaId),
                      builder: (context, favoritoSnapshot) {
                        if (favoritoSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        bool isFavoritada = favoritoSnapshot.data ?? false;

                        return IconButton(
                          icon: Icon(
                            isFavoritada ? Icons.favorite : Icons.favorite_border,
                            color: isFavoritada ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            if (isFavoritada) {
                              await _empresaFavoritaService.removerDosFavoritos(empresaId);
                            } else {
                              await _empresaFavoritaService.adicionarAosFavoritos(
                                empresaId: empresaId,
                                fornecedorId: dados['fornecedorId'] ?? '', // Adiciona o fornecedorId
                                nome: nome,
                                resumo: resumo,
                                avaliacao: avaliacao,
                                quantidadeAvaliacoes: quantidadeAvaliacoes,
                              );
                            }
                            setState(() {}); // Atualiza a UI
                          },
                        );
                      },
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.white,
                            title: Text(
                              nome,
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
                                    "Descrição: $descricao",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "Avaliação: ${avaliacao.toStringAsFixed(1)} ($quantidadeAvaliacoes avaliações)",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
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
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}