import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../Models/convidado_model.dart';
import '../FirestoreService/convidado_service.dart';
import '../Widgets/guest_card.dart'; // Importando a classe GuestCard


class GuestListScreen extends StatefulWidget {
  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  final ConvidadoService _convidadoService = ConvidadoService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Função para adicionar um convidado
  void _addGuest() async {
    _nameController.clear();
    _emailController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Adicionar Convidado',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final email = _emailController.text;

                if (name.isNotEmpty && email.isNotEmpty) {
                  await _convidadoService.addGuest(
                    name: name,
                    email: email,
                    statusPresenca: 'esperando', // Status padrão
                  );

                  Navigator.pop(context); // Fecha o diálogo
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos.')),
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
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Função para editar um convidado
  void _editGuest(Guest guest) async {
    _nameController.text = guest.name;
    _emailController.text = guest.email;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Editar Convidado',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final email = _emailController.text;

                if (name.isNotEmpty && email.isNotEmpty) {
                  await _convidadoService.updateGuest(
                    guest.id,
                    name: name,
                    email: email,
                  );

                  Navigator.pop(context); // Fecha o diálogo
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos.')),
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
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Função para remover um convidado
  void _deleteGuest(String guestId) async {
    bool confirmDelete = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Remover Convidado',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Tem certeza que deseja remover este convidado?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                confirmDelete = true;
                Navigator.pop(context); // Fecha o diálogo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Remover',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      await _convidadoService.deleteGuest(guestId);
    }
  }

  // Função para enviar email
  Future<void> _sendEmail(String email) async {
    print('Iniciando processo de envio de email...');
    print('Email do destinatário: $email');

    if (!isValidEmail(email)) {
      print('Email inválido: $email');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Email inválido. Verifique o endereço de email.')),
      );
      return;
    }

    // Controladores para os campos de título e corpo do email
    final TextEditingController _subjectController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();

    // Exibe o diálogo para o usuário preencher o título e o corpo do email
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Enviar Email',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Título do Email',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Corpo do Email',
                  labelStyle: TextStyle(color: Colors.purple),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final subject = _subjectController.text;
                final body = _bodyController.text;

                if (subject.isNotEmpty && body.isNotEmpty) {
                  final Email emailConfig = Email(
                    body: body,
                    subject: subject,
                    recipients: [email],
                    isHTML: false,
                  );

                  try {
                    await FlutterEmailSender.send(emailConfig);
                    print('Email enviado com sucesso!');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email enviado com sucesso!')),
                    );
                  } catch (error) {
                    print('Erro ao enviar email: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao enviar email: $error')),
                    );
                  }

                  Navigator.pop(context); // Fecha o diálogo
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha o título e o corpo do email.')),
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
                'Enviar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Função para validar o formato do email
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  // Função para atualizar o status de presença
  Future<void> _updatePresenceStatus(
      String guestId, String statusPresenca) async {
    await _convidadoService.updatePresenceStatus(guestId, statusPresenca);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Convidados",
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Guest>>(
          stream: _convidadoService.getGuests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text("Erro ao carregar convidados.",
                      style: TextStyle(color: Colors.white)));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text("Nenhum convidado encontrado.",
                      style: TextStyle(color: Colors.white)));
            }

            final guests = snapshot.data!;

            return ListView.builder(
              itemCount: guests.length,
              itemBuilder: (context, index) {
                final guest = guests[index];
                return GuestCard(
                  guest: guest,
                  onDelete: () => _deleteGuest(guest.id),
                  onEdit: () => _editGuest(guest),
                  onSendEmail: () => _sendEmail(guest.email),
                  onUpdatePresenceStatus: (status) =>
                      _updatePresenceStatus(guest.id, status),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGuest,
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}