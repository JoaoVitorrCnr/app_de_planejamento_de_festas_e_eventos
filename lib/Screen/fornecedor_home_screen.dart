import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../FirestoreService/empresa_service.dart';

class FornecedorHomeScreen extends StatefulWidget {
  @override
  _FornecedorHomeScreenState createState() => _FornecedorHomeScreenState();
}

class _FornecedorHomeScreenState extends State<FornecedorHomeScreen> {
  final EmpresaService _firestoreService = EmpresaService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _fazerLogout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Erro ao fazer logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao fazer logout: $e")),
      );
    }
  }

  Future<void> _adicionarEmpresa() async {
    final _formKey = GlobalKey<FormState>();
    String _nome = '';
    String _resumo = '';
    String _descricao = '';
    String _cnpj = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Adicionar Empresa",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nome",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira o nome da empresa";
                      }
                      return null;
                    },
                    onSaved: (value) => _nome = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Resumo",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira um resumo";
                      }
                      return null;
                    },
                    onSaved: (value) => _resumo = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira uma descrição";
                      }
                      return null;
                    },
                    onSaved: (value) => _descricao = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "CNPJ",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira o CNPJ";
                      }
                      return null;
                    },
                    onSaved: (value) => _cnpj = value!,
                  ),
                ],
              ),
            ),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  try {
                    await _firestoreService.adicionarEmpresa(
                      nome: _nome,
                      resumo: _resumo,
                      descricao: _descricao,
                      cnpj: _cnpj,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Empresa adicionada com sucesso!")),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Adicionar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirEmpresa(String empresaId) async {
    await _firestoreService.excluirEmpresa(empresaId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Empresa excluída com sucesso!")),
    );
  }

  Future<void> _editarEmpresa(String empresaId, Map<String, dynamic> empresa) async {
    final _formKey = GlobalKey<FormState>();
    String _nome = empresa['nome'];
    String _resumo = empresa['resumo'];
    String _descricao = empresa['descricao'];
    String _cnpj = empresa['cnpj'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Editar Empresa",
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _nome,
                    decoration: InputDecoration(
                      labelText: "Nome",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira o nome da empresa";
                      }
                      return null;
                    },
                    onSaved: (value) => _nome = value!,
                  ),
                  TextFormField(
                    initialValue: _resumo,
                    decoration: InputDecoration(
                      labelText: "Resumo",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira um resumo";
                      }
                      return null;
                    },
                    onSaved: (value) => _resumo = value!,
                  ),
                  TextFormField(
                    initialValue: _descricao,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira uma descrição";
                      }
                      return null;
                    },
                    onSaved: (value) => _descricao = value!,
                  ),
                //  TextFormField(
                  //  initialValue: _cnpj,
                   // decoration: InputDecoration(
                    //  labelText: "CNPJ",
                     // labelStyle: TextStyle(color: Colors.purple),
                     // focusedBorder: UnderlineInputBorder(
                     //   borderSide: BorderSide(color: Colors.purple),
                     // ),
                  //  ),
                  //  validator: (value) {
                    //  if (value == null || value.isEmpty) {
                    //    return "Por favor, insira o CNPJ";
                   //   }
                   //   return null;
                  //  },
                  //  onSaved: (value) => _cnpj = value!,
                 // ),
                ],
              ),
            ),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  try {
                    await _firestoreService.editarEmpresa(
                      empresaId: empresaId,
                      nome: _nome,
                      resumo: _resumo,
                      descricao: _descricao,
                      cnpj: _cnpj,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Empresa atualizada com sucesso!")),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Salvar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas Empresas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _fazerLogout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.obterEmpresas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Nenhuma empresa cadastrada.",
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

              return Card(
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
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
                               // Text(
                                //  "CNPJ: ${dados['cnpj']}",
                                 // style: TextStyle(fontSize: 14),
                               // ),
                                //SizedBox(height: 16),
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
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dados['nome'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          dados['resumo'],
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
                              "Avaliação: ${dados['avaliacao'].toStringAsFixed(1)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.purple),
                              onPressed: () => _editarEmpresa(empresa.id, dados),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirEmpresa(empresa.id),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarEmpresa,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}