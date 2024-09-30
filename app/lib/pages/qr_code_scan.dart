import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final String apiUrlSaldos = "http://127.0.0.1:8000/event/api/saldos/";
  final String apiUrlTransacoes = "http://127.0.0.1:8000/event/api/transacoes/";

  String? qrValue;
  String? tipoTransacao;
  double? valor;
  String? evento;
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
              onDetect: (BarcodeCapture barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                for (var barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    final String code = barcode.rawValue!;
                    print('QR Code detectado: $code');
                    _processQrData(code);
                  }
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
        valor = qrData['value'] ?? 0.0;
        evento = qrData['currency'] ?? "ceaa8388-3a87-4a17-ad40-5815f249ed35";
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
            Text('ID do Evento: $evento', style: TextStyle(fontSize: 18)),
            Text('ID da Transação: $idTransacao', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _efetuarRecarga,
              child: Text('Efetuar Recarga'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _efetuarRecarga() async {
    if (tipoTransacao != null && valor != null && evento != null && idTransacao != null) {
      try {
        Map<String, dynamic> transacaoData = {
          "value": valor,
          "type": tipoTransacao!.toLowerCase(),
          "hash": idTransacao,
          "currency": "ceaa8388-3a87-4a17-ad40-5815f249ed35", // Valor padrão
        };

        final response = await http.post(
          Uri.parse(apiUrlTransacoes),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(transacaoData),
        );

        if (response.statusCode == 201) {
          print('Transação registrada com sucesso.');
          // Após registrar a transação, atualize o saldo
          await _atualizarSaldo(evento!, valor!, 'ceaa8388-3a87-4a17-ad40-5815f249ed35', context);
        } else {
          print('Erro ao registrar a transação: ${response.body}');
          _showErrorDialog(context, 'Erro ao registrar a transação.');
        }
      } catch (e) {
        print('Erro: $e');
      }
    }
  }

  Future<void> _atualizarSaldo(String evento, double valor, String uid, BuildContext context) async {
    try {
      // Primeiro, obtenha o saldo atual
      final responseGet = await http.get(
        Uri.parse("$apiUrlSaldos$uid/"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (responseGet.statusCode == 200) {
        Map<String, dynamic> saldoData = jsonDecode(responseGet.body);
        double saldoAtual = double.parse(saldoData['currency']);  // Valor atual do saldo

        // Agora, modifique o saldo dependendo do tipo de transação
        if (tipoTransacao == 'recarga') {
          saldoAtual += valor;  // Adiciona o valor ao saldo
        } else if (tipoTransacao == 'debito') {
          saldoAtual -= valor;  // Subtrai o valor do saldo
        }

        // Atualiza o saldo com o novo valor
        Map<String, dynamic> saldoAtualizado = {
          "currency": saldoAtual.toString(),
        };

        final responsePatch = await http.patch(
          Uri.parse("$apiUrlSaldos$uid/"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(saldoAtualizado),
        );

        if (responsePatch.statusCode == 200) {
          print('Saldo atualizado com sucesso.');
          _showSuccessDialog(context, tipoTransacao!, valor);
        } else {
          print('Erro ao atualizar o saldo: ${responsePatch.body}');
          _showErrorDialog(context, 'Erro ao atualizar o saldo.');
        }
      } else {
        print('Erro ao obter o saldo atual: ${responseGet.body}');
        _showErrorDialog(context, 'Erro ao obter o saldo atual.');
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
    String message = tipoTransacao == 'recarga'
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
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : this;
  }
}
