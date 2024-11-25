import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/pages/events/pagina_evento.dart';

class UserEventsPage extends StatefulWidget {
  @override
  _UserEventsPageState createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> _eventosParticipando = [];
  List<dynamic> _eventosNaoParticipando = [];
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Duração da animação
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 100), () {
            _animationController.reverse(); // Voltar à opacidade inicial
          });
        }
      });

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.3).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');
    print('User UID: $userUid');

    // Requisição para pegar os saldos
    final saldoResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/event/api/saldos/'));

    if (saldoResponse.statusCode == 200) {
      List<dynamic> saldos = jsonDecode(saldoResponse.body);
      print('Saldos recebidos: $saldos');

      List<int> eventIds = saldos
          .where((saldo) => saldo['user'] == userUid)
          .map<int>((saldo) => saldo['event'] as int)
          .toList();

      print('Event IDs filtrados: $eventIds');

      // Fetch eventos e separar os que o usuário está participando e os que não está
      await _fetchEventDetails(eventIds);
    } else {
      print('Erro ao buscar saldos: ${saldoResponse.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchEventDetails(List<int> eventIds) async {
    final eventosResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/event/api/eventos/'));
    if (eventosResponse.statusCode == 200) {
      List<dynamic> eventos = jsonDecode(eventosResponse.body);
      print('Eventos recebidos: $eventos');

      setState(() {
        // Separar os eventos em duas listas
        _eventosParticipando =
            eventos.where((evento) => eventIds.contains(evento['id'])).toList();
        _eventosNaoParticipando = eventos
            .where((evento) => !eventIds.contains(evento['id']))
            .toList();
        _isLoading = false;
      });
    } else {
      print('Erro ao buscar eventos: ${eventosResponse.statusCode}');
    }
  }

  // Função para criar saldo se não existir
  Future<void> _createBalanceAndEnterEvent(dynamic evento) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');

    // Verificar se já existe saldo para o evento
    final saldoResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/event/api/saldos/'));
    if (saldoResponse.statusCode == 200) {
      List<dynamic> saldos = jsonDecode(saldoResponse.body);
      bool hasBalance = saldos.any((saldo) =>
          saldo['user'] == userUid && saldo['event'] == evento['id']);

      if (!hasBalance) {
        // Se não tiver saldo, criar um saldo
        final createBalanceResponse = await http.post(
          Uri.parse('http://127.0.0.1:8000/event/api/saldos/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'uid': userUid,
            'event': evento['id'],
            'currency': 0, // Ajuste conforme necessário
            'user': userUid
          }),
        );

        if (createBalanceResponse.statusCode == 201) {
          print('Saldo criado com sucesso!');
        } else {
          print('Erro ao criar saldo: ${createBalanceResponse.statusCode}');
        }
      }

      // Após criar o saldo (se necessário), navegar para o evento
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailPage(eventId: evento['id']),
        ),
      );
    } else {
      print('Erro ao buscar saldos: ${saldoResponse.statusCode}');
    }
  }

  // Função para construir o botão com animação de piscar
  Widget _buildJoinButton(dynamic evento) {
    return GestureDetector(
      onTap: () async {
        _animationController.forward(); // Inicia a animação de piscar ao clicar
        await _createBalanceAndEnterEvent(
            evento); // Verifica e cria saldo se necessário
      },
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: ElevatedButton(
              onPressed:
                  null, // Controle do clique é feito pelo GestureDetector
              child: Text('Entrar em Evento'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 152, 4, 215), // Cor do botão
                foregroundColor:
                    const Color.fromARGB(255, 14, 0, 0), // Cor do texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Eventos')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Exibir os eventos que o usuário está participando
                  _eventosParticipando.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Eventos que estou participando',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ..._eventosParticipando.map((evento) {
                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    title: Text(evento['name']),
                                    subtitle: Text(evento['description']),
                                    trailing: _buildJoinButton(evento),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        )
                      : Container(),

                  // Exibir os eventos que o usuário não está participando
                  _eventosNaoParticipando.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Eventos que não estou participando',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ..._eventosNaoParticipando.map((evento) {
                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    title: Text(evento['name']),
                                    subtitle: Text(evento['description']),
                                    trailing: _buildJoinButton(evento),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
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
