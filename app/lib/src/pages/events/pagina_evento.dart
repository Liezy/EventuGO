import 'package:flutter/material.dart';
import 'transacao_qr_page.dart'; // Certifique-se de que o caminho esteja correto
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;

  EventDetailPage({required this.eventId});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  dynamic _eventData;
  String? _saldo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
    _fetchUserSaldo();
  }

  Future<void> _fetchEventDetails() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/event/api/eventos/${widget.eventId}/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _eventData = jsonDecode(response.body);
      });
    } else {
      print('Falha ao buscar detalhes do evento: ${response.statusCode}');
    }
  }

  Future<void> _fetchUserSaldo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');

    final saldoResponse = await http.get(
      Uri.parse('http://127.0.0.1:8000/event/api/saldos/'),
    );

    if (saldoResponse.statusCode == 200) {
      List<dynamic> saldos = jsonDecode(saldoResponse.body);

      // Encontrar o saldo do evento com base no `eventId` e `userUid`
      var saldo = saldos.firstWhere(
          (s) => s['event'] == widget.eventId && s['user'] == userUid,
          orElse: () => null);

      if (saldo != null) {
        setState(() {
          _saldo = saldo['currency']; // Busca o campo 'currency' do saldo
        });
      } else {
        print('Saldo não encontrado para este evento e usuário.');
      }
    } else {
      print('Falha ao buscar saldo: ${saldoResponse.statusCode}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _eventData == null
              ? Center(child: Text('Erro ao carregar os dados do evento'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Placeholder da foto do evento
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.event, size: 50),
                      ),
                      SizedBox(height: 20),
                      // Nome do evento
                      Text(
                        _eventData['name'] ?? 'Nome do evento não disponível',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Descrição do evento
                      Text(
                        _eventData['description'] ??
                            'Descrição do evento não disponível',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Saldo do usuário no evento
                      Text(
                        _saldo != null
                            ? 'Saldo: $_saldo'
                            : 'Saldo indisponível',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Botões de ações
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(Icons.history, 'Histórico'),
                          _buildActionButton(Icons.attach_money, 'Recarga'),
                          _buildActionButton(Icons.shopping_cart, 'Comprar'),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: () {
            if (label == 'Recarga') {
              // Navega para TransacaoQrPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransacaoQrPage()),
              );
            } else {
              // Outras ações
            }
          },
        ),
        Text(label),
      ],
    );
  }
}
