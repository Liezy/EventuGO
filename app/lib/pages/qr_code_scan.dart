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

  String? qrValue; // Para armazenar o valor do QR Code
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
                    _processQrData(code); // Processa os dados do QR Code
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

  // Processa os dados do QR Code e atualiza o estado
  void _processQrData(String code) {
    setState(() {
      print('Código QR detectado: $code'); // Debug
      try {
        Map<String, dynamic> qrData = jsonDecode(code);
        tipoTransacao = qrData['type'];
        valor = qrData['value'] ?? 0.0;
        // Definindo um valor padrão para currency
        evento = qrData['currency'] ?? "ceaa8388-3a87-4a17-ad40-5815f249ed35";
        idTransacao = qrData['hash'];
        qrValue = code; // Armazena o valor do QR Code
        print('Dados do QR Code processados: $qrData'); // Debug
      } catch (e) {
        print('Erro ao processar dados do QR Code: $e'); // Debug
      }
    });
  }

  // Cria a interface para exibir os dados do QR Code
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

  // Método para efetuar a recarga
  Future<void> _efetuarRecarga() async {
    if (tipoTransacao != null && valor != null && evento != null && idTransacao != null) {
      try {
        Map<String, dynamic> transacaoData = {
          "value": valor,
          "type": tipoTransacao!.toLowerCase(),
          "hash": idTransacao,
          "currency": "ceaa8388-3a87-4a17-ad40-5815f249ed35", // Usando valor padrão
        };

        final response = await http.post(
          Uri.parse(apiUrlTransacoes),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(transacaoData),
        );

        print('Resposta da API: ${response.statusCode} - ${response.body}'); // Debug

        if (response.statusCode == 201) {
          print('Transação registrada com sucesso.');
          // Após registrar a transação, atualize o saldo
          await _atualizarSaldo(evento!, valor!, 'ceaa8388-3a87-4a17-ad40-5815f249ed35', context); // uid fictício do saldo
        } else {
          print('Erro ao registrar a transação: ${response.body}');
          _showErrorDialog(context, 'Erro ao registrar a transação.');
        }
      } catch (e) {
        print('Erro: $e');
      }
    }
  }

  // Método para atualizar o saldo usando PATCH
  Future<void> _atualizarSaldo(String evento, double valor, String uid, BuildContext context) async {
    try {
      Map<String, dynamic> saldoData = {
        "currency": valor.toString(),  // Atualiza apenas o campo currency
      };

      final response = await http.patch(
        Uri.parse("$apiUrlSaldos$uid/"),  // O uid do saldo específico
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(saldoData),
      );

      print('Resposta da API de saldo: ${response.statusCode} - ${response.body}'); // Debug

      if (response.statusCode == 200) {
        print('Saldo atualizado com sucesso.');
        _showSuccessDialog(context, tipoTransacao!, valor);
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

// Extensão para capitalizar a primeira letra
extension StringExtension on String {
  String capitalizeFirst() {
    return this.length > 0 ? this[0].toUpperCase() + this.substring(1) : this;
  }
}
