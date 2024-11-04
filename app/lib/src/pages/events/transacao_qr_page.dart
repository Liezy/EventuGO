import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TransacaoQrPage extends StatefulWidget {
  @override
  _TransacaoQrPageState createState() => _TransacaoQrPageState();
}

class _TransacaoQrPageState extends State<TransacaoQrPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _eventoController = TextEditingController();
  String _tipoTransacao = 'Recarga'; // Valor padrão
  String? _qrData; // Variável para armazenar os dados do QR Code

  // Método para gerar o ID da transação
  String _gerarIdTransacao() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Método para gerar os dados do QR Code
  void _gerarQRCode() {
    if (_formKey.currentState!.validate()) {
      String idTransacao = _gerarIdTransacao();
      setState(() {
        _qrData = jsonEncode({
          'value': double.tryParse(_valorController.text) ?? 0.0,
          'type':
              _tipoTransacao.toLowerCase(), // Exemplo: "recarga" ou "débito"
          'hash': idTransacao, // ID da transação
          'currency': _eventoController.text, // Use o evento como identificador
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Recarga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _valorController,
                        decoration: InputDecoration(labelText: 'Valor'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira um valor';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _tipoTransacao,
                        decoration:
                            InputDecoration(labelText: 'Tipo de Transação'),
                        items: <String>['Recarga']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _tipoTransacao = newValue!;
                          });
                        },
                      ),
                      TextFormField(
                        controller: _eventoController,
                        decoration: InputDecoration(labelText: 'ID do Evento'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o ID do evento';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _gerarQRCode,
                        child: Text('Gerar QR Code'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_qrData !=
                  null) // Exibe o QR Code apenas se os dados existirem
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: QrImageView(
                      data: _qrData!, // Dados para o QR Code
                      version: QrVersions.auto,
                      size: 200.0,
                      gapless: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
