// guest_card.dart
import 'package:flutter/material.dart';
import '../Models/convidado_model.dart';
import 'presence_status_button.dart';

class GuestCard extends StatelessWidget {
  final Guest guest;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onSendEmail;
  final Function(String) onUpdatePresenceStatus;

  const GuestCard({
    required this.guest,
    required this.onDelete,
    required this.onEdit,
    required this.onSendEmail,
    required this.onUpdatePresenceStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome e Email
            Text(
              guest.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Email: ${guest.email}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Convite: ${guest.statusPresenca}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            // Botões de funcionalidades
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão de status de presença
                IconButton(
                  icon: Icon(Icons.event_available,
                      size: 28, color: Colors.purple),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white,
                          title: Text(
                            'Definir Status de Presença',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return PresenceStatusButton(
                                currentStatus: guest.statusPresenca,
                                onStatusChanged: (newStatus) {
                                  onUpdatePresenceStatus(newStatus); // Atualiza o status no banco de dados
                                  setState(() {
                                    guest.statusPresenca = newStatus; // Atualiza o estado local
                                  });
                                },
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Fechar',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                // Botão de enviar email
                IconButton(
                  icon: Icon(Icons.email, size: 28, color: Colors.purple),
                  onPressed: onSendEmail,
                ),
                // Botão de editar
                IconButton(
                  icon: Icon(Icons.edit, size: 28, color: Colors.purple),
                  onPressed: onEdit,
                ),
                // Botão de deletar
                IconButton(
                  icon: Icon(Icons.delete, size: 28, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}