import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Adicione o pacote de scanner
import '../../widgets/action_button.dart';
import '../../widgets/text_field.dart';

class EventEntryPage extends StatefulWidget {
  @override
  _EventEntryPageState createState() => _EventEntryPageState();
}

class _EventEntryPageState extends State<EventEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventIdController = TextEditingController();
  String? _qrData;

  // Método para gerar os dados do QR Code com base no ID do evento existente
  void _gerarQRCode() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _qrData = jsonEncode({
          'event_id': _eventIdController.text,
        });
      });
    }
  }

  // Função para processar o QR code escaneado e entrar no evento
  void _processarQrCode(String qrCodeData) {
    try {
      Map<String, dynamic> qrData = jsonDecode(qrCodeData);
      final String? eventId = qrData['event_id'];
      if (eventId != null) {
        _showSuccessDialog(context, 'Você entrou no evento com ID: $eventId');
      } else {
        _showErrorDialog(context, 'QR Code inválido.');
      }
    } catch (e) {
      _showErrorDialog(context, 'QR Code inválido.');
    }
  }

  // Exibir diálogo de sucesso
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sucesso'),
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

  // Exibir diálogo de erro
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

  // Função para escanear o QR code usando a câmera
  void _escanearQrCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Escanear QR Code')),
          body: MobileScanner(
            onDetect: (barcodeCapture) {
              for (final barcode in barcodeCapture.barcodes) {
                if (barcode.rawValue != null) {
                  final qrCodeData = barcode.rawValue!;
                  Navigator.of(context)
                      .pop(); // Fecha o scanner ao detectar o QR code
                  _processarQrCode(qrCodeData); // Processa o QR code escaneado
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrada no Evento via QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextField(
                      _eventIdController,
                      'ID do Evento',
                    ),
                    SizedBox(height: 20),
                    buildActionButton(
                      'Criar QR Code',
                      Colors.green,
                      Colors.white,
                      Icons.qr_code,
                      _gerarQRCode,
                    ),
                    SizedBox(height: 10),
                    buildActionButton(
                      'Escanear QR Code',
                      Colors.blue,
                      Colors.white,
                      Icons.qr_code_scanner,
                      _escanearQrCode,
                    ),
                  ],
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
