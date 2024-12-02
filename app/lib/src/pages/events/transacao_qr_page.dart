import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TransacaoQrPage extends StatefulWidget {
  @override
  _TransacaoQrPageState createState() => _TransacaoQrPageState();
}

class _TransacaoQrPageState extends State<TransacaoQrPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _valorController = TextEditingController();
  String? _qrData; // Dados para o QR Code
  String? _userUid; // ID do usuário
  String? _selectedEventId; // ID do evento selecionado
  String? _saldoUid; // UID do saldo do usuário para o evento
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchUserAndEventData();
  }

  // Inicializa as notificações locais
  Future<void> _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Ícone do app
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  // Notificação de sucesso
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

  // Notificação de erro
  Future<void> _showErrorNotification(String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'recarga_channel', // ID do canal
      'Erro', // Nome do canal
      channelDescription: 'Notificações de erro',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin!.show(
      0, // ID da notificação
      'Erro na Operação', // Título
      message, // Mensagem do corpo
      notificationDetails,
    );
  }

  // Busca os dados do usuário e evento selecionado
  Future<void> _fetchUserAndEventData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userUid = prefs.getString('user_uid');
        _selectedEventId = prefs.getString('selected_event_id');
      });

      if (_userUid != null && _selectedEventId != null) {
        await _fetchSaldoUid(); // Busca o UID do saldo para o evento
      } else {
        _showErrorNotification("Dados do usuário ou evento não encontrados.");
      }
    } catch (e) {
      _showErrorNotification("Erro ao buscar dados: $e");
    }
  }

  // Busca o UID do saldo do usuário para o evento selecionado
  Future<void> _fetchSaldoUid() async {
    try {
      final saldoResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/event/api/saldos/'));

      if (saldoResponse.statusCode == 200) {
        List<dynamic> saldos = jsonDecode(utf8.decode(saldoResponse.bodyBytes));

        // Filtra o saldo para o user e evento selecionados
        var saldo = saldos.firstWhere(
          (s) =>
              s['user'] == _userUid &&
              s['event'].toString() == _selectedEventId,
          orElse: () => null,
        );

        if (saldo != null) {
          setState(() {
            _saldoUid = saldo['uid'];
          });
        } else {
          _showErrorNotification(
              "Saldo não encontrado para o usuário e evento.");
        }
      } else {
        _showErrorNotification(
            "Erro ao buscar saldos. Status: ${saldoResponse.statusCode}");
      }
    } catch (e) {
      _showErrorNotification("Erro ao buscar dados de saldo: $e");
    }
  }

  // Gera os dados do QR Code com o UID do saldo
  void _gerarQRCode(double valorRecarga) {
    // Verifica se todos os dados necessários estão presentes
    if (_formKey.currentState!.validate()) {
      if (_saldoUid == null) {
        _showErrorNotification('Saldo não encontrado. Tente novamente.');
        return;
      }

      if (_selectedEventId == null) {
        _showErrorNotification('Evento não selecionado. Tente novamente.');
        return;
      }

      setState(() {
        _qrData = jsonEncode({
          'saldo_uid': _saldoUid!,
          'valor_recarga': valorRecarga,
          'event_id': _selectedEventId,
        });
      });

      _showSuccessNotification();
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
                      decoration: InputDecoration(
                        labelText: 'Valor para Recarga',
                        prefixText: 'R\$ ',
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um valor';
                        }
                        // Adiciona validação para garantir que é um número válido
                        final numValue = double.tryParse(value);
                        if (numValue == null || numValue <= 0) {
                          return 'Por favor, insira um valor válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Valida o formulário antes de gerar o QR Code
                          if (_formKey.currentState!.validate()) {
                            double valorRecarga =
                                double.tryParse(_valorController.text) ?? 0.0;
                            _gerarQRCode(valorRecarga);
                          }
                        },
                        icon: Icon(Icons.qr_code), // Ícone de QR Code
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
              if (_qrData != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: QrImageView(
                      data: _qrData!,
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

  @override
  void dispose() {
    // Limpa o controller quando o widget for descartado
    _valorController.dispose();
    super.dispose();
  }
}
