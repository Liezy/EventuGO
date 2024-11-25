import 'dart:convert';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/src/pages/home/home_page.dart'; // Importando a HomePage

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final String apiUrlSaldos = "http://127.0.0.1:8000/event/api/saldos/";
  final storage = FlutterSecureStorage();
  bool _isQrScanned = false; // Evita duplicações no QR Code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner de QR Code'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retroceder automaticamente
          },
        ),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          if (_isQrScanned) return; // Evita duplicações

          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (var barcode in barcodes) {
            if (barcode.rawValue != null) {
              final String code = barcode.rawValue!;
              print('QR Code detectado: $code');
              _processQrData(
                  code, context); // Passa o contexto para mostrar a mensagem
              _isQrScanned = true; // Marca que o QR foi escaneado
            }
          }
        },
      ),
    );
  }

  void _processQrData(String code, BuildContext context) async {
    String evento = code; // Número do evento lido do QR Code
    print('Número do evento lido: $evento');

    // Chama a função para criar a instância de saldo
    await _criarSaldo(evento, context);
  }

  Future<void> _criarSaldo(String evento, BuildContext context) async {
    try {
      final userUuid = await storage.read(key: 'user_uuid');
      if (userUuid == null) {
        _showErrorDialog(
            context, 'Usuário não encontrado no armazenamento seguro.');
        return;
      }

      final saldoData = {
        "user": userUuid,
        "event": evento,
        "currency": "0.00", // Valor padrão
      };

      final response = await http.post(
        Uri.parse(apiUrlSaldos),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(saldoData),
      );

      if (response.statusCode == 201) {
        print('Instância de saldo criada com sucesso.');

        // Exibir o SnackBar antes de navegar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entrou no evento com sucesso!')),
        );

        // Aguardar a animação do SnackBar ser concluída antes de navegar
        await Future.delayed(Duration(seconds: 1));

        // Navegar para a HomePage corretamente
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp()), // Redireciona para a HomePage
          (route) => false, // Remove todas as rotas anteriores
        );
      } else {
        _showErrorDialog(context, 'Erro ao criar instância de saldo.');
      }
    } catch (e) {
      print('Erro: $e');
      _showErrorDialog(context, 'Erro ao tentar criar instância de saldo.');
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
}
