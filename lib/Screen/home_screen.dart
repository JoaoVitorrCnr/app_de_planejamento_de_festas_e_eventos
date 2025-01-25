import 'package:flutter/material.dart';
import 'listaConv_screen.dart'; // Importe a tela da lista de convidados
import 'package:firebase_auth/firebase_auth.dart'; // Importe o Firebase Auth para desconectar
import 'orcamento_screen.dart'; // Importe a tela de orçamento
import 'cronograma_screen.dart'; // Importe a tela de cronograma

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para desconectar o usuário
  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    // Navegar de volta para a tela de login (ou outra tela inicial)
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple, // Cor temática
        centerTitle: true,
        elevation: 0,
        // Adiciona um ícone de desconexão no canto superior direito
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white), // Ícone de logout
            onPressed: () => _signOut(context), // Chama a função de desconexão
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão para acessar a lista de convidados
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestListScreen(), // Navega para a lista de convidados
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Lista de Convidados",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20), // Espaço entre os botões
            // Botão para acessar o controle de gastos
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrcamentoScreen(), // Navega para a tela de orçamento
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Controle de Gastos",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20), // Espaço entre os botões
            // Botão para acessar o cronograma
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CronogramaScreen(), // Navega para a tela de cronograma
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Cronograma",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}