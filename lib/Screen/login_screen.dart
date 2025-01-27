import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // Tela inicial do usuário normal
import 'fornecedor_home_screen.dart'; // Tela inicial do fornecedor
import 'signup_screen.dart'; // Tela de cadastro

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Faz o login com e-mail e senha
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Obtém o UID do usuário logado
        String uid = userCredential.user!.uid;
        print("UID do usuário logado: $uid"); // Print do UID

        // Verifica se o UID está na coleção `fornecedores`
        DocumentSnapshot fornecedorDoc = await FirebaseFirestore.instance
            .collection('fornecedores')
            .doc(uid)
            .get();

        if (fornecedorDoc.exists) {
          print("Usuário identificado como FORNECEDOR."); // Print de depuração

          // Verifica se o widget ainda está montado antes de redirecionar
          if (mounted) {
            // Se o UID está na coleção `fornecedores`, redireciona para a tela de fornecedor
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FornecedorHomeScreen()),
            );
          }
        } else {
          // Se não está na coleção `fornecedores`, verifica se está na coleção `usuarios`
          DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(uid)
              .get();

          if (usuarioDoc.exists) {
            print(
                "Usuário identificado como USUÁRIO NORMAL."); // Print de depuração

            // Verifica se o widget ainda está montado antes de redirecionar
            if (mounted) {
              // Se o UID está na coleção `usuarios`, redireciona para a tela de usuário normal
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          } else {
            print("Usuário NÃO ENCONTRADO nas coleções."); // Print de depuração

            // Verifica se o widget ainda está montado antes de exibir a mensagem de erro
            if (mounted) {
              // Se o UID não está em nenhuma das coleções, exibe uma mensagem de erro
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Usuário não encontrado.")),
              );
            }
          }
        }
      } catch (e) {
        print("Erro ao logar: $e"); // Print de erro

        // Verifica se o widget ainda está montado antes de exibir a mensagem de erro
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao logar: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Planejamento de Festas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  "Bem-vindo ao MyPartyPlanner!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira um e-mail";
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor, insira uma senha";
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Não tem uma conta? Cadastre-se",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
