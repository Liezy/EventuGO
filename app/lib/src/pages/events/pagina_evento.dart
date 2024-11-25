import 'package:flutter/material.dart';
import 'transacao_qr_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/pages/events/carrinho_page.dart';
import 'package:app/src/pages/events/listagem_eventos.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;

  EventDetailPage({required this.eventId});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  dynamic _eventData;
  List<dynamic> _produtos = [];
  List<dynamic> _carrinho = [];
  String? _saldo;
  bool _isLoading = true;
  int? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails(); // Detalhes do evento são carregados apenas uma vez
    _fetchProdutos(); // Produtos são carregados apenas uma vez
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserSaldo(); // Atualiza o saldo toda vez que a página é carregada
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

      var saldo = saldos.firstWhere(
          (s) => s['event'] == widget.eventId && s['user'] == userUid,
          orElse: () => null);

      if (saldo != null) {
        setState(() {
          _saldo = saldo['currency'];
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

  Future<void> _fetchProdutos() async {
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/event/api/produtos/?event_id=${widget.eventId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _produtos = jsonDecode(response.body);
      });
    } else {
      print('Falha ao buscar produtos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Navega para a página de listagem de eventos sem remover as rotas anteriores
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserEventsPage(), // Página de listagem de eventos
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _eventData == null
              ? Center(child: Text('Erro ao carregar os dados do evento'))
              : SingleChildScrollView(
                  child: Padding(
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
                            _buildActionButton(Icons.shopping_cart, 'Carrinho'),
                          ],
                        ),
                        SizedBox(height: 30),
                        // Lista de produtos em cards
                        Text(
                          'Produtos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        _produtos.isEmpty
                            ? Text('Nenhum produto encontrado.')
                            : GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: _produtos.length,
                                itemBuilder: (context, index) {
                                  final produto = _produtos[index];
                                  return _buildProdutoCard(produto);
                                },
                              ),
                      ],
                    ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransacaoQrPage()),
              );
            } else if (label == 'Carrinho') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarrinhoPage(
                    produtosNoCarrinho: _carrinho,
                    eventoId:
                        widget.eventId, // Passe o ID do evento selecionado
                  ),
                ),
              );
            } // Outras ações
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildProdutoCard(dynamic produto) {
    return GestureDetector(
      onTap: () async {
        // Inicia o efeito de piscar
        setState(() {
          _selectedProductId = produto['id'];
        });

        // Aguarda um breve momento para o efeito de piscar
        await Future.delayed(Duration(milliseconds: 300));

        setState(() {
          _selectedProductId = null;
        });

        // Exibe o diálogo de confirmação
        _showAddToCartDialog(produto);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _selectedProductId == produto['id']
              ? Colors.blue[100]
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag,
                  size: 50, color: const Color.fromARGB(255, 152, 4, 215)),
              SizedBox(height: 10),
              Text(
                produto['name'] ?? 'Nome indisponível',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Preço: R\$ ${(double.tryParse(produto['value']) ?? 0.0).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToCartDialog(dynamic produto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar ao carrinho'),
          content: Text('Deseja adicionar "${produto['name']}" ao carrinho?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addToCart(produto);
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(dynamic produto) {
    // Lógica para adicionar ao carrinho
    setState(() {
      _carrinho.add(produto);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto['name']} adicionado ao carrinho!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
