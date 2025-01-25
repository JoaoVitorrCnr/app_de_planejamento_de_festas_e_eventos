import 'package:flutter/material.dart';

class Tarefa {
  String id;
  String nome;
  String descricao;
  DateTime data;
  TimeOfDay horario;
  bool concluida;

  Tarefa({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.horario,
    this.concluida = false,
  });

  // Converte um Map para um objeto Tarefa
  factory Tarefa.fromMap(String id, Map<String, dynamic> map) {
    return Tarefa(
      id: id,
      nome: map['nome'],
      descricao: map['descricao'],
      data: DateTime.parse(map['data']),
      horario: TimeOfDay(
        hour: map['horario']['hour'],
        minute: map['horario']['minute'],
      ),
      concluida: map['concluida'],
    );
  }

  // Converte um objeto Tarefa para um Map
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'horario': {'hour': horario.hour, 'minute': horario.minute},
      'concluida': concluida,
    };
  }
}