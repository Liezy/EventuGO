import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaSaldoHistoricoPage extends StatefulWidget {
  @override
  _ConsultaSaldoHistoricoPageState createState() => _ConsultaSaldoHistoricoPageState();
}

class _ConsultaSaldoHistoricoPageState extends State<ConsultaSaldoHistoricoPage> {
  final TextEditingController _usuarioUidController = TextEditingController();
  List<dynamic> _eventos = [];
  bool _loading = false;

  Future<void> buscarEventos() async {
    setState(() {
      _loading = true;
    });

    final String usuarioUid = _usuarioUidController.text;

    final eventosUrl = Uri.parse('http://127.0.0.1:8000/event/api/eventos/'); // URL da API que retorna eventos para o UID do usuário

    final response = await http.get(eventosUrl);

    if (response.statusCode == 200) {
      setState(() {
        _eventos = jsonDecode(response.body);
        _loading = false;
      });
    } else {
      setState(() {
        _eventos = [];
        _loading = false;
      });
      print('Erro ao buscar eventos: ${response.body}');
    }
  }

  Future<void> consultarSaldo(String usuarioUid, String eventoId) async {
    final saldoUrl = Uri.parse('http://127.0.0.1:8000/credits/api/saldo/$usuarioUid/$eventoId/');

    final response = await http.get(saldoUrl);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saldo: R\$${responseData['saldo']}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao consultar saldo.')),
      );
    }
  }

  Future<void> consultarHistorico(String usuarioUid, String eventoId) async {
    final historicoUrl = Uri.parse('http://127.0.0.1:8000/credits/api/historico/$usuarioUid/$eventoId/');

    final response = await http.get(historicoUrl);

    if (response.statusCode == 200) {
      final List<dynamic> historico = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Histórico de Transações'),
            content: Container(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: historico.length,
                itemBuilder: (context, index) {
                  final transacao = historico[index];
                  return ListTile(
                    title: Text('Tipo: ${transacao['tipo']}'),
                    subtitle: Text('Valor: R\$${transacao['valor']} - Data: ${transacao['data']}'),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao consultar histórico.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta Saldo e Histórico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usuarioUidController,
              decoration: InputDecoration(labelText: 'UID do Usuário'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: buscarEventos,
              child: Text('Buscar Eventos'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: _eventos.isEmpty
                        ? Text('Nenhum evento encontrado.')
                        : ListView.builder(
                            itemCount: _eventos.length,
                            itemBuilder: (context, index) {
                              final evento = _eventos[index];
                              return Card(
                                child: ListTile(
                                  title: Text('Evento: ${evento['nome']}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Descrição: ${evento['descricao']}'),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => consultarSaldo(_usuarioUidController.text, evento['id'].toString()),
                                            child: Text('Consultar Saldo'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => consultarHistorico(_usuarioUidController.text, evento['id'].toString()),
                                            child: Text('Consultar Histórico'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
