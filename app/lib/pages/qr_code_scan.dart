import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final String apiUrlTransacoes = "http://127.0.0.1:8000/event/api/transacoes/";
  final String apiUrlSaldos = "http://127.0.0.1:8000/event/api/saldos/";
  final String defaultUuid = "fc54e943-6a14-42a1-8a92-096d415ff9a2";

  String? qrValue;
  String? tipoTransacao;
  double? valor;
  String? eventoUuid;
  String? idTransacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner de QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  _processQrData(barcode.rawValue ?? '');
                }
              },
            ),
          ),
          if (qrValue != null) _buildQrDataDisplay(),
        ],
      ),
    );
  }

  void _processQrData(String code) {
    setState(() {
      print('Código QR detectado: $code');
      try {
        Map<String, dynamic> qrData = jsonDecode(code);
        tipoTransacao = qrData['type'];
        valor = double.parse(qrData['value'].toString());
        eventoUuid = isValidUUID(qrData['currency']) ? qrData['currency'] : defaultUuid;
        idTransacao = qrData['hash'];
        qrValue = code;
        print('Dados do QR Code processados: $qrData');
      } catch (e) {
        print('Erro ao processar dados do QR Code: $e');
      }
    });
  }

  Widget _buildQrDataDisplay() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo de Transação: ${tipoTransacao?.capitalizeFirst()}',
                style: TextStyle(fontSize: 18)),
            Text('Valor: R\$ ${valor?.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            Text('UUID do Evento: $eventoUuid', style: TextStyle(fontSize: 18)),
            Text('ID da Transação: $idTransacao', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _efetuarTransacao,
              child: Text('Efetuar Recarga'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _efetuarTransacao() async {
    if (tipoTransacao != null && valor != null && eventoUuid != null && idTransacao != null) {
      if (!isValidUUID(eventoUuid!)) {
        _showErrorDialog(context, 'UUID inválido. Usando UUID padrão.');
        eventoUuid = defaultUuid;
      }

      try {
        // Define o tipo de transação: 0 para Recarga, 1 para Débito
        int transactionType = tipoTransacao?.toLowerCase() == 'recarga' ? 0 : 1;
        Map<String, dynamic> transacaoData = {
          "value": valor,
          "type": transactionType,
          "hash": idTransacao,
          "currency": eventoUuid,
        };

        final responseTransacao = await http.post(
          Uri.parse(apiUrlTransacoes),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(transacaoData),
        );

        if (responseTransacao.statusCode == 201) {
          print('Transação registrada com sucesso.');
          await _atualizarSaldo(eventoUuid!, valor!, transactionType);
        } else {
          print('Erro ao registrar a transação: ${responseTransacao.body}');
          _showErrorDialog(context, 'Erro ao registrar a transação: ${responseTransacao.body}');
        }
      } catch (e) {
        print('Erro: $e');
        _showErrorDialog(context, 'Erro ao processar a transação: $e');
      }
    }
  }

  Future<void> _atualizarSaldo(String saldoUuid, double valorTransacao, int transactionType) async {
    try {
      final responseGet = await http.get(
        Uri.parse("$apiUrlSaldos$saldoUuid/"),
        headers: {"Content-Type": "application/json"},
      );

      if (responseGet.statusCode == 200) {
        Map<String, dynamic> saldoData = jsonDecode(responseGet.body);
        double saldoAtual = double.parse(saldoData['currency'].toString());
        double novoSaldo = transactionType == 0 ? saldoAtual + valorTransacao : saldoAtual - valorTransacao;

        if (novoSaldo < 0) {
          _showErrorDialog(context, 'Saldo insuficiente para realizar a transação.');
          return;
        }

        Map<String, dynamic> saldoAtualizado = {
          "currency": novoSaldo.toString(),
        };

        final responsePatch = await http.patch(
          Uri.parse("$apiUrlSaldos$saldoUuid/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(saldoAtualizado),
        );

        if (responsePatch.statusCode == 200) {
          print('Saldo atualizado com sucesso.');
          _showSuccessDialog(context, transactionType, valorTransacao);
        } else {
          print('Erro ao atualizar o saldo: ${responsePatch.body}');
          _showErrorDialog(context, 'Erro ao atualizar o saldo: ${responsePatch.body}');
        }
      } else {
        print('Erro ao obter o saldo atual: ${responseGet.body}');
        _showErrorDialog(context, 'Erro ao obter o saldo atual: ${responseGet.body}');
      }
    } catch (e) {
      print('Erro: $e');
      _showErrorDialog(context, 'Erro ao atualizar o saldo: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, int transactionType, double valor) {
    String message = transactionType == 0
        ? 'Recarga de R\$ ${valor.toStringAsFixed(2)} realizada com sucesso!'
        : 'Débito de R\$ ${valor.toStringAsFixed(2)} realizado com sucesso!';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transação Concluída'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool isValidUUID(String uuid) {
    RegExp uuidRegExp = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegExp.hasMatch(uuid);
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    return this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  }
}