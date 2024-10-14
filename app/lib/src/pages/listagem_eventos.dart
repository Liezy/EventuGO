import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserEventsPage extends StatefulWidget {
  @override
  _UserEventsPageState createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage> {
  List<dynamic> _eventos = [];
  List<int> _eventIds = []; // Para armazenar os IDs dos eventos do usuário
  bool _isLoading = true; // Para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _fetchUserEvents(); // Chama a função para buscar os eventos do usuário
  }

  Future<void> _fetchUserEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');

    // Primeiro, busca os saldos do usuário
    final saldoResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/event/api/saldos/'));
    if (saldoResponse.statusCode == 200) {
      List<dynamic> saldos = jsonDecode(saldoResponse.body);
      // Filtra os eventos associados ao usuário
      _eventIds = saldos
          .where((saldo) => saldo['user'] == userUid)
          .map<int>((saldo) => saldo['event'] as int)
          .toList();

      // Agora busca os detalhes dos eventos
      await _fetchEventDetails();
    } else {
      print('Falha ao buscar saldos: ${saldoResponse.statusCode}');
      setState(() {
        _isLoading = false; // Para parar o carregamento mesmo em caso de falha
      });
    }
  }

  Future<void> _fetchEventDetails() async {
    if (_eventIds.isNotEmpty) {
      final eventosResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/event/api/eventos/'));
      if (eventosResponse.statusCode == 200) {
        List<dynamic> eventos = jsonDecode(eventosResponse.body);
        // Filtra os eventos com base nos IDs
        _eventos = eventos
            .where((evento) => _eventIds.contains(evento['id']))
            .toList();
      } else {
        print('Falha ao buscar eventos: ${eventosResponse.statusCode}');
      }
    }
    setState(() {
      _isLoading =
          false; // Para parar o carregamento após tentar buscar os eventos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Eventos')),
      backgroundColor: Colors.white,
      body: _isLoading // Verifica se está carregando
          ? Center(
              child:
                  CircularProgressIndicator()) // Exibe carregando enquanto busca
          : _eventos.isEmpty // Verifica se a lista de eventos está vazia
              ? Center(
                  child: Text('Nenhum evento encontrado',
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                )
              : ListView.builder(
                  itemCount: _eventos.length,
                  itemBuilder: (context, index) {
                    final evento = _eventos[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16), // Margem ao redor do card
                      child: Card(
                        elevation: 4, // Sombra do card
                        color: Colors.white, // Cor de fundo do card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Raio do círculo reduzido
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Padding interno do card
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey, // Placeholder para a imagem
                                  // borderRadius: BorderRadius.circular(
                                  //     10), // Bordas arredondadas
                                  border: Border.all(
                                    color: _getBorderColor(
                                        evento), // Define a cor da borda
                                    width: 3, // Largura da borda
                                  ),
                                ),
                                child: Icon(Icons.event,
                                    size: 40), // Ícone do evento
                              ),
                              SizedBox(
                                  width:
                                      16), // Espaçamento entre a imagem e o texto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      evento['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        height:
                                            4), // Espaço entre o nome e a descrição
                                    Text(
                                      evento['description'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8), // Espaço para o status
                              _getEventStatus(
                                  evento), // Função para obter o status do evento
                            ],
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
      return Colors.amber; // Borda amarela
    } else if (now.isAfter(endDate)) {
      return Colors.red; // Borda vermelha
    } else {
      return Colors.green; // Borda verde
    }
  }
}
