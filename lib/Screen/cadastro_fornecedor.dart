import 'package:flutter/material.dart';
import 'package:app_de_planejamento_de_festas_e_eventos/FirestoreService/add_fornecedor.dart'; // Importa o serviço do Firestore

class SupplierScreen extends StatefulWidget {
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _serviceController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _saveSupplier() async {
    if (_formKey.currentState!.validate()) {
      await _firestoreService.saveSupplier(
        _nameController.text,
        _phoneController.text,
        _serviceController.text,
      );
      // Limpa os campos após salvar
      _nameController.clear();
      _phoneController.clear();
      _serviceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Fornecedores"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o nome";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o telefone";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serviceController,
                decoration: InputDecoration(labelText: "Serviço"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o serviço";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSupplier,
                child: Text("Salvar Fornecedor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}