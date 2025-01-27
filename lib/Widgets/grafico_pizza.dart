import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Models/despesa_model.dart';

class PieChartWidget extends StatelessWidget {
  final List<Despesa> despesas;

  const PieChartWidget({Key? key, required this.despesas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica se todos os valores são zero
    bool todosZeros = despesas.every((despesa) => despesa.valor == 0);

    // Gera os dados para o gráfico de pizza
    List<PieChartSectionData> sections = [];
    if (todosZeros) {
      // Exibe uma única seção com 100% e uma mensagem
      sections.add(
        PieChartSectionData(
          color: Colors.grey, // Cor para indicar "sem dados"
          value: 100,
          title: '0%',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else {
      // Calcula o total do orçamento
      double total = despesas.fold(0, (sum, despesa) => sum + despesa.valor);

      // Gera as seções para cada categoria
      sections = despesas.map((despesa) {
        final double porcentagem = (despesa.valor / total) * 100;
        return PieChartSectionData(
          color: _getCorCategoria(despesa.categoria),
          value: porcentagem,
          title: '${porcentagem.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }).toList();
    }

    return Column(
      children: [
        // Gráfico de pizza
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        // Legenda (apenas se houver dados)
        if (!todosZeros)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildLegenda(),
          ),
      ],
    );
  }

  // Constrói a legenda
  Widget _buildLegenda() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: despesas.map((despesa) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              color: _getCorCategoria(despesa.categoria),
            ),
            SizedBox(width: 8),
            Text(
              despesa.categoria,
              style: TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Retorna uma cor com base na categoria
  Color _getCorCategoria(String categoria) {
    switch (categoria) {
      case 'Decoração':
        return Colors.blue;
      case 'Buffet':
        return Colors.green;
      case 'Entretenimento':
        return Colors.orange;
      case 'Outros':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}