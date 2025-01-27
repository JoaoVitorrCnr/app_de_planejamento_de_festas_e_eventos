import 'package:flutter/material.dart';
import 'listaConv_screen.dart'; // Importe a tela da lista de convidados
import 'package:firebase_auth/firebase_auth.dart'; // Importe o Firebase Auth para desconectar
import 'orcamento_screen.dart'; // Importe a tela de orçamento
import 'cronograma_screen.dart'; // Importe a tela de cronograma
import 'todas_empresas_screen.dart'; // Importe a nova tela de todas as empresas

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Dois botões por linha
          crossAxisSpacing: 16, // Espaçamento horizontal entre os botões
          mainAxisSpacing: 16, // Espaçamento vertical entre os botões
          children: [
            // Botão para acessar a lista de convidados
            _buildMenuButton(
              context,
              "Lista de Convidados",
              Icons.people,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestListScreen(), // Navega para a lista de convidados
                  ),
                );
              },
            ),
            // Botão para acessar o controle de gastos
            _buildMenuButton(
              context,
              "Controle de Gastos",
              Icons.attach_money,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrcamentoScreen(), // Navega para a tela de orçamento
                  ),
                );
              },
            ),
            // Botão para acessar o cronograma
            _buildMenuButton(
              context,
              "Cronograma",
              Icons.calendar_today,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CronogramaScreen(), // Navega para a tela de cronograma
                  ),
                );
              },
            ),
            // Botão para acessar a tela de todas as empresas
            _buildMenuButton(
              context,
              "Fornecedores",
              Icons.business,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodasEmpresasScreen(), // Navega para a tela de todas as empresas
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir botões do menu
  Widget _buildMenuButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.purple,
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}