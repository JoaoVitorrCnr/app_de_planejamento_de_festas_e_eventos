import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'Screen/login_screen.dart'; // Importa a tela de login
import 'Screen/home_screen.dart'; // Importa a tela home
import 'Screen/fornecedor_home_screen.dart'; // Importa a tela do fornecedor
import 'Screen/listaConv_screen.dart'; // Importa a tela da lista de convidados

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planejamento de Festas',
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      theme: ThemeData(
        primarySwatch: Colors.purple, // Define a cor temática
      ),
      // Verifica o estado de autenticação do usuário
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Mostra um loading enquanto verifica
          } else if (snapshot.hasData) {
            // Usuário autenticado, verifica se é fornecedor ou usuário normal
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('fornecedores')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, fornecedorSnapshot) {
                if (fornecedorSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Mostra um loading enquanto verifica
                } else if (fornecedorSnapshot.hasData && fornecedorSnapshot.data!.exists) {
                  // Usuário é um fornecedor
                  return FornecedorHomeScreen();
                } else {
                  // Usuário não é um fornecedor, verifica se é um usuário normal
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(snapshot.data!.uid)
                        .get(),
                    builder: (context, usuarioSnapshot) {
                      if (usuarioSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator()); // Mostra um loading enquanto verifica
                      } else if (usuarioSnapshot.hasData && usuarioSnapshot.data!.exists) {
                        // Usuário é um usuário normal
                        return HomeScreen();
                      } else {
                        // Usuário não encontrado em nenhuma das coleções
                        return LoginScreen();
                      }
                    },
                  );
                }
              },
            );
          } else {
            // Usuário não autenticado, redireciona para a LoginScreen
            return LoginScreen();
          }
        },
      ),
      // Define as rotas nomeadas
      routes: {
        '/home': (context) => HomeScreen(),
       // '/guestList': (context) => GuestListScreen(),
        '/homeFornecedor': (context) => FornecedorHomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}