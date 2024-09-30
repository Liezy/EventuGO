import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreditosPage extends StatelessWidget {
  final TextEditingController _valorCreditoController = TextEditingController();
  final String _usuarioId = '1';
  final String _eventoId = '1';

  Future<void> adicionarCreditos(BuildContext context) async {
    final String valorCredito = _valorCreditoController.text;

    final url = Uri.parse('http://127.0.0.1:8000/credits/api/transacoes/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': _usuarioId,
        'evento': _eventoId,
        'tipo': 'RECARGA',
        'valor': valorCredito,
      }),
    );

    if (response.statusCode == 201) {
      print('Créditos adicionados com sucesso');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Créditos adicionados com sucesso!')),
      );
    } else {
      print('Falha ao adicionar créditos: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao adicionar créditos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créditos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Saldo Atual: R\$100,00', style: TextStyle(fontSize: 24)),
            TextFormField(
              controller: _valorCreditoController,
              decoration: InputDecoration(labelText: 'Valor dos Créditos'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                adicionarCreditos(context);
              },
              child: Text('Adicionar Créditos'),
            ),
          ],
        ),
      ),
    );
  }
}
