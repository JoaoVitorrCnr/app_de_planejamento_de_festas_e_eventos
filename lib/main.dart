import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importe o Firebase Auth
import 'firebase_options.dart';
import 'Screen/login_screen.dart'; // Importa a tela de login
import 'Screen/home_screen.dart'; // Importa a tela home
import '../Screen/listaConv_screen.dart'; // Importa a tela da lista de convidados

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
            return HomeScreen(); // Usuário autenticado, redireciona para a HomeScreen
          } else {
            return LoginScreen(); // Usuário não autenticado, redireciona para a LoginScreen
          }
        },
      ),
      // Define as rotas nomeadas
      routes: {
        '/home': (context) => HomeScreen(),
        '/guestList': (context) => GuestListScreen(),
      },
    );
  }
}