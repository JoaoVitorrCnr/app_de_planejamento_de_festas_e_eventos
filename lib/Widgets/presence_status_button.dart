// presence_status_button.dart
import 'package:flutter/material.dart';

class PresenceStatusButton extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const PresenceStatusButton({
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botão "Aceito"
        IconButton(
          icon: Icon(Icons.check,
              color: currentStatus == 'aceito' ? Colors.green : Colors.grey),
          onPressed: () => onStatusChanged('aceito'),
        ),
        // Botão "Esperando Confirmação"
        IconButton(
          icon: Icon(Icons.access_time,
              color: currentStatus == 'esperando resposta' ? Colors.orange : Colors.grey),
          onPressed: () => onStatusChanged('esperando resposta'),
        ),
        // Botão "Recusado"
        IconButton(
          icon: Icon(Icons.close,
              color: currentStatus == 'recusado' ? Colors.red : Colors.grey),
          onPressed: () => onStatusChanged('recusado'),
        ),
      ],
    );
  }
}