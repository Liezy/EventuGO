import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class QrCodeScanPage extends StatelessWidget {
  final String apiUrlSaldos = "http://127.0.0.1:8000/event/api/saldos/";
  final String apiUrlTransacoes = "http://127.0.0.1:8000/event/api/transacoes/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner de QR Code'),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture barcodeCapture) async {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (var barcode in barcodes) {
            if (barcode.rawValue != null) {
              final String code = barcode.rawValue!;
              print('QR Code detectado: $code');

              // Decodifica o JSON contido no QR Code
              Map<String, dynamic> qrData = jsonDecode(code);

              // Chama a função para processar a transação
              await _processarTransacao(qrData, context);
            }
          }
        },
      ),
    );
  }

  Future<void> _processarTransacao(Map<String, dynamic> qrData, BuildContext context) async {
    try {
      // Extrai os valores do QR Code
      String tipoTransacao = qrData['tipo'];
      double valor = double.tryParse(qrData['valor']) ?? 0.0;
      String evento = qrData['evento'];
      String idTransacao = qrData['id'];

      // Dados da transação a serem enviados à API
      Map<String, dynamic> transacaoData = {
        "value": valor,
        "type": tipoTransacao,
        "hash": idTransacao,  // Você pode usar o ID da transação como hash
        "event": evento
      };

      // Faz a requisição POST para o endpoint de transações
      final response = await http.post(
        Uri.parse(apiUrlTransacoes),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(transacaoData),
      );

      if (response.statusCode == 201) {
        // Transação registrada com sucesso
        print('Transação registrada com sucesso.');

        // Atualiza o saldo do usuário após a transação
        await _atualizarSaldo(evento, valor, tipoTransacao, context);
      } else {
        print('Erro ao registrar a transação: ${response.body}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> _atualizarSaldo(String evento, double valor, String tipoTransacao, BuildContext context) async {
    try {
      // Dados para atualizar o saldo
      Map<String, dynamic> saldoData = {
        "currency": valor,  // O saldo a ser ajustado
        "event": evento,
        // Outros dados necessários como user id se necessário
      };

      // Envia a requisição POST para o endpoint de saldo
      final response = await http.post(
        Uri.parse(apiUrlSaldos),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(saldoData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Saldo atualizado com sucesso.');
        _showSuccessDialog(context, tipoTransacao, valor);
      } else {
        print('Erro ao atualizar o saldo: ${response.body}');
        _showErrorDialog(context, 'Erro ao atualizar o saldo.');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String tipoTransacao, double valor) {
    String message = tipoTransacao == 'Recarga'
        ? 'Recarga de R\$ $valor realizada com sucesso!'
        : 'Débito de R\$ $valor realizado com sucesso!';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transação Concluída'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();  // Retorna para a página anterior
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
