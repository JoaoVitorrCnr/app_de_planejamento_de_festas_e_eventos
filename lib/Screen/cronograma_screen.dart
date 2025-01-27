import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl
import '../FirestoreService/tarefa_service.dart';
import '../Models/tarefa_model.dart';

class CronogramaScreen extends StatefulWidget {
  @override
  _CronogramaScreenState createState() => _CronogramaScreenState();
}

class _CronogramaScreenState extends State<CronogramaScreen> {
  final TarefaService _tarefaService = TarefaService();

  // Função para ordenar as tarefas por data e horário
  List<Tarefa> _ordenarTarefas(List<Tarefa> tarefas) {
    tarefas.sort((a, b) {
      // Compara as datas
      int comparacaoData = a.data.compareTo(b.data);
      if (comparacaoData != 0) return comparacaoData;

      // Se as datas forem iguais, compara os horários
      int horaA = a.horario.hour;
      int minutoA = a.horario.minute;
      int horaB = b.horario.hour;
      int minutoB = b.horario.minute;

      if (horaA != horaB) return horaA.compareTo(horaB);
      return minutoA.compareTo(minutoB);
    });

    return tarefas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cronograma de Eventos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Tarefa>>(
        stream: _tarefaService.getTarefas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar tarefas.'));
          }

          final tarefas = snapshot.data ?? [];
          final tarefasOrdenadas = _ordenarTarefas(tarefas); // Ordena as tarefas

          return ListView.builder(
            itemCount: tarefasOrdenadas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefasOrdenadas[index];
              return GestureDetector(
                onTap: () {
                  _mostrarDetalhesTarefa(context, tarefa);
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Checkbox para marcar a tarefa como concluída
                        IconButton(
                          icon: Icon(
                            tarefa.concluida ? Icons.check_box : Icons.check_box_outline_blank,
                            color: Colors.purple,
                          ),
                          onPressed: () => _tarefaService.alternarConclusao(tarefa.id, !tarefa.concluida),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tarefa.nome,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${DateFormat('dd/MM/yyyy').format(tarefa.data)} - ${tarefa.horario.format(context)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botão para editar a tarefa
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.purple),
                          onPressed: () => _mostrarFormularioTarefa(context, tarefa),
                        ),
                        // Botão para remover a tarefa
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _tarefaService.removerTarefa(tarefa.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioTarefa(context, null),
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Mostra o formulário para adicionar/editar uma tarefa
  void _mostrarFormularioTarefa(BuildContext context, Tarefa? tarefaExistente) {
    final nomeController = TextEditingController(text: tarefaExistente?.nome);
    final descricaoController = TextEditingController(text: tarefaExistente?.descricao);
    DateTime data = tarefaExistente?.data ?? DateTime.now();
    TimeOfDay horario = tarefaExistente?.horario ?? TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            tarefaExistente == null ? 'Adicionar Tarefa' : 'Editar Tarefa',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Tarefa',
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
                SizedBox(height: 10),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
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
                ListTile(
                  title: Text('Data: ${DateFormat('dd/MM/yyyy').format(data)}'),
                  trailing: Icon(Icons.calendar_today, color: Colors.purple),
                  onTap: () async {
                    final novaData = await showDatePicker(
                      context: context,
                      initialDate: data,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (novaData != null) {
                      setState(() {
                        data = novaData;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text('Horário: ${horario.format(context)}'),
                  trailing: Icon(Icons.access_time, color: Colors.purple),
                  onTap: () async {
                    final novoHorario = await showTimePicker(
                      context: context,
                      initialTime: horario,
                    );
                    if (novoHorario != null) {
                      setState(() {
                        horario = novoHorario;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final novaTarefa = Tarefa(
                  id: tarefaExistente?.id ?? DateTime.now().toString(),
                  nome: nomeController.text,
                  descricao: descricaoController.text,
                  data: data,
                  horario: horario,
                );
                if (tarefaExistente == null) {
                  _tarefaService.adicionarTarefa(novaTarefa);
                } else {
                  _tarefaService.editarTarefa(novaTarefa);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                tarefaExistente == null ? 'Adicionar' : 'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Mostra os detalhes da tarefa
  void _mostrarDetalhesTarefa(BuildContext context, Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            tarefa.nome,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descrição: ${tarefa.descricao}'),
                SizedBox(height: 16),
                Text('Data: ${DateFormat('dd/MM/yyyy').format(tarefa.data)}'),
                Text('Horário: ${tarefa.horario.format(context)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Fechar',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }
}