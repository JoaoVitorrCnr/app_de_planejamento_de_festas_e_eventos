import 'package:flutter/material.dart';
import '../FirestoreService/orcamento_service.dart';
import '../Models/despesa_model.dart';
import '../Widgets/grafico_pizza.dart';

class OrcamentoScreen extends StatefulWidget {
  @override
  _OrcamentoScreenState createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  final OrcamentoService _firestoreService = OrcamentoService();
  List<Despesa> despesas = [];

  @override
  void initState() {
    super.initState();
    _carregarDespesas();
  }

  // Carrega as despesas do Firestore
  Future<void> _carregarDespesas() async {
    try {
      List<Despesa> despesasCarregadas =
          await _firestoreService.carregarDespesas();
      print("Despesas carregadas: $despesasCarregadas"); // Verifique no console
      setState(() {
        despesas = despesasCarregadas;
      });
    } catch (e) {
      print("Erro ao carregar despesas: $e");
    }
  }

  // Atualiza uma despesa no Firestore
  Future<void> _atualizarDespesa(int index, double novoValor) async {
    try {
      Despesa despesa = despesas[index];
      double valorAtualizado = despesa.valor + novoValor;

      await _firestoreService.salvarDespesa(despesa.categoria, valorAtualizado);
      await _carregarDespesas();
    } catch (e) {
      print("Erro ao atualizar despesa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Controle de Gastos',
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
        color: Colors.white, // Fundo branco
        child: Column(
          children: [
            // Gráfico de pizza
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChartWidget(despesas: despesas),
                ),
              ),
            ),
            // Lista de cards
            Expanded(
              child: ListView.builder(
                itemCount: despesas.length,
                itemBuilder: (context, index) {
                  return _buildDespesaCard(despesas[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      // Removi o FloatingActionButton
    );
  }

  Widget _buildDespesaCard(Despesa despesa, int index) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinha os itens
          children: [
            Expanded(
              // Expande o nome da despesa para ocupar o espaço disponível
              child: Text(
                despesa.categoria,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                overflow: TextOverflow
                    .ellipsis, // Evita que o texto ultrapasse o espaço
              ),
            ),
            SizedBox(width: 16), // Espaço entre o nome e o valor
            Container(
              width: 100, // Largura fixa para o valor
              alignment: Alignment.centerRight, // Alinha o valor à direita
              child: Text(
                'R\$ ${despesa.valor.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.purple),
                  onPressed: () => _mostrarDialogoAjuste(context, index, false),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.purple),
                  onPressed: () => _mostrarDialogoAjuste(context, index, true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoAjuste(
      BuildContext context, int index, bool isAdicionar) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Text(
            isAdicionar ? 'Adicionar Valor' : 'Subtrair Valor',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Valor',
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
          actions: [
            if (!isAdicionar)
              TextButton(
                child: Text(
                  'Zerar',
                  style: TextStyle(color: Colors.purple),
                ),
                onPressed: () async {
                  await _atualizarDespesa(index, -despesas[index].valor);
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.purple),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              onPressed: () async {
                double valor = double.tryParse(_controller.text) ?? 0.0;
                if (isAdicionar) {
                  await _atualizarDespesa(index, valor);
                } else {
                  await _atualizarDespesa(index, -valor);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Confirmar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
