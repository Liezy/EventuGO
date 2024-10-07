import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroEventoPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeEventoController = TextEditingController();
  final TextEditingController _descricaoEventoController =
      TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _dataFimController = TextEditingController();

  Future<void> cadastrarEvento() async {
    final String nomeEvento = _nomeEventoController.text;
    final String descricaoEvento = _descricaoEventoController.text;
    final String dataInicio = _dataInicioController.text;
    final String dataFim = _dataFimController.text;

    final url = Uri.parse('http://127.0.0.1:8000/event/api/eventos/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': nomeEvento,
        'description': descricaoEvento,
        'type': '1',
        'start_date': dataInicio,
        'end_date': dataFim,
        'company': '1',
      }),
    );

    if (response.statusCode == 201) {
      print('Evento cadastrado com sucesso');
    } else {
      print('Falha no cadastro do evento: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Evento'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeEventoController,
                decoration: InputDecoration(labelText: 'Nome do Evento'),
              ),
              TextFormField(
                controller: _descricaoEventoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _dataInicioController,
                decoration:
                    InputDecoration(labelText: 'Data de Início (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _dataFimController,
                decoration:
                    InputDecoration(labelText: 'Data de Fim (YYYY-MM-DD)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cadastrarEvento();
                  }
                },
                child: Text('Cadastrar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
