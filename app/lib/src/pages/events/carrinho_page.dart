import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CarrinhoPage extends StatefulWidget {
  final List<dynamic> produtosNoCarrinho;
  final int eventoId; // Adiciona o evento

  CarrinhoPage({required this.produtosNoCarrinho, required this.eventoId});

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  double _calcularTotal() {
    return widget.produtosNoCarrinho.fold(0.0, (total, produto) {
      return total + (double.tryParse(produto['value']) ?? 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = _calcularTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
      ),
      body: widget.produtosNoCarrinho.isEmpty
          ? Center(
              child: Text(
                'Seu carrinho está vazio!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.produtosNoCarrinho.length,
                    itemBuilder: (context, index) {
                      final produto = widget.produtosNoCarrinho[index];
                      return ListTile(
                        leading: Icon(Icons.shopping_bag),
                        title: Text(produto['name'] ?? 'Nome indisponível'),
                        subtitle: Text(
                            'Preço: R\$ ${(double.tryParse(produto['value']) ?? 0.0).toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.produtosNoCarrinho.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Divider(height: 2, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Total a pagar: R\$ ${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final totalCompra = _calcularTotal();
                          await atualizarSaldo(context, totalCompra, widget.eventoId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Compra realizada (fictício)'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        child: Text('Finalizar Compra'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

    Future<void> atualizarSaldo(BuildContext context, double totalCompra, int eventoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');

    if (userUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: Usuário não autenticado.')),
      );
      return;
    }

    try {
      // 1. Buscar saldo do cliente
      final saldoResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/event/api/saldos/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (saldoResponse.statusCode != 200) {
        throw Exception('Erro ao buscar saldo do cliente');
      }

      final List<dynamic> saldos = jsonDecode(saldoResponse.body);
      final saldoCliente = saldos.firstWhere(
        (saldo) => saldo['user'] == userUid && saldo['event'] == eventoId,
        orElse: () => null,
      );

      if (saldoCliente == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: Saldo não encontrado para este evento.')),
        );
        return;
      }

      final double saldoAtual = double.tryParse(saldoCliente['currency']) ?? 0.0;

      if (saldoAtual < totalCompra) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saldo insuficiente para a compra.')),
        );
        return;
      }

      // 2. Atualizar saldo do cliente
      final novoSaldo = saldoAtual - totalCompra;
      final saldoUid = saldoCliente['uid'];

      final updateResponse = await http.patch(
        Uri.parse('http://127.0.0.1:8000/event/api/saldos/$saldoUid/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'currency': novoSaldo.toStringAsFixed(2)}),
      );

      if (updateResponse.statusCode != 200) {
        throw Exception('Erro ao atualizar saldo do cliente');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saldo atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar saldo: $e')),
      );
    }
  }

}