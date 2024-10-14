import 'dart:convert';
import 'package:app/src/pages/events/pagina_evento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserEventsPage extends StatefulWidget {
  @override
  _UserEventsPageState createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage> {
  List<dynamic> _eventos = [];
  List<int> _eventIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
  }

  Future<void> _fetchUserEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');

    final saldoResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/event/api/saldos/'));
    if (saldoResponse.statusCode == 200) {
      List<dynamic> saldos = jsonDecode(saldoResponse.body);
      _eventIds = saldos
          .where((saldo) => saldo['user'] == userUid)
          .map<int>((saldo) => saldo['event'] as int)
          .toList();

      await _fetchEventDetails();
    } else {
      print('Falha ao buscar saldos: ${saldoResponse.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchEventDetails() async {
    if (_eventIds.isNotEmpty) {
      final eventosResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/event/api/eventos/'));
      if (eventosResponse.statusCode == 200) {
        List<dynamic> eventos = jsonDecode(eventosResponse.body);
        _eventos = eventos
            .where((evento) => _eventIds.contains(evento['id']))
            .toList();
      } else {
        print('Falha ao buscar eventos: ${eventosResponse.statusCode}');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Eventos')),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _eventos.isEmpty
              ? Center(
                  child: Text('Nenhum evento encontrado',
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                )
              : ListView.builder(
                  itemCount: _eventos.length,
                  itemBuilder: (context, index) {
                    final evento = _eventos[index];
                    return GestureDetector(
                      onTap: () {
                        // Navega para a tela de detalhes ao clicar no evento
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailPage(
                              eventId: evento['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(
                                      color: _getBorderColor(evento),
                                      width: 3,
                                    ),
                                  ),
                                  child: Icon(Icons.event, size: 40),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        evento['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        evento['description'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                _getEventStatus(evento),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _getEventStatus(dynamic evento) {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime.parse(evento['start_date']);
    DateTime endDate = DateTime.parse(evento['end_date']);

    if (now.isBefore(startDate)) {
      return Text('Vai Acontecer');
    } else if (now.isAfter(endDate)) {
      return Text('Já Aconteceu');
    } else {
      return Text('Está Acontecendo');
    }
  }

  Color _getBorderColor(dynamic evento) {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime.parse(evento['start_date']);
    DateTime endDate = DateTime.parse(evento['end_date']);

    if (now.isBefore(startDate)) {
      return Colors.amber;
    } else if (now.isAfter(endDate)) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
