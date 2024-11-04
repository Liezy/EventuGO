import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransacaoQrPage extends StatefulWidget {
  @override
  _TransacaoQrPageState createState() => _TransacaoQrPageState();
}

class _TransacaoQrPageState extends State<TransacaoQrPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _valorController = TextEditingController();
  String? _qrData; // Dados para o QR Code
  String? _idCarteira;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _fetchIdCarteira();
    _initializeNotifications();
  }

  // Inicializa as notificações locais
  Future<void> _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Defina o ícone do app
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  // Envia a notificação de recarga bem-sucedida
  Future<void> _showSuccessNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'recarga_channel', // ID do canal
      'Recarga', // Nome do canal
      channelDescription: 'Notificações de recarga',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin!.show(
      0, // ID da notificação
      'Recarga Realizada', // Título
      'Sua recarga foi realizada com sucesso!', // Corpo
      notificationDetails,
    );
  }

  // Método para buscar o id da carteira em shared preferences
  Future<void> _fetchIdCarteira() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idCarteira = prefs.getString(
          'user_uid'); // Certifique-se de que user_uid é o id correto
    });
  }

  // Método para gerar os dados do QR Code e enviar notificação
  void _gerarQRCode() {
    if (_formKey.currentState!.validate() && _idCarteira != null) {
      setState(() {
        _qrData = jsonEncode({
          'id_carteira': _idCarteira!,
          'valor_recarga': double.tryParse(_valorController.text) ?? 0.0,
        });
      });
      _showSuccessNotification(); // Envia a notificação após a geração do QR Code
    } else {
      print("ID da carteira não encontrado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Recarga'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _valorController,
                      decoration:
                          InputDecoration(labelText: 'Valor para Recarga'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um valor';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _gerarQRCode,
                        icon: Icon(
                            Icons.attach_money), // Ícone de adição de dinheiro
                        label: Text('Gerar QR Code'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
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
