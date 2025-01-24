import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Screen/login_screen.dart'; // Importa a tela de login

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
      home: LoginScreen(), // Define a tela de login como a tela inicial
    );
  }
}