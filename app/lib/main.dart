import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Eventos e Créditos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(), // Tela principal
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(), // Exibe a HomePage
          CadastroUsuarioPage(), // Tela de Cadastro de Usuário
          CadastroEventoPage(), // Tela de Cadastro de Evento
          CreditosPage(), // Tela de Créditos
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue, // Cor dos ícones selecionados
        unselectedItemColor: Colors.grey, // Cor dos ícones não selecionados
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Evento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Créditos',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Bem-vindo à Home Page!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class CadastroUsuarioPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> cadastrarUsuario() async {
    final String nome = _nomeController.text;
    final String email = _emailController.text;
    final String senha = _senhaController.text;

    final url = Uri.parse('http://127.0.0.1:8000/users/api/users/'); //URL

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': nome,
        'email': email,
        'password': senha, // Altere para o campo esperado pela API
        'first_name': 'dudun',
        'last_name': 'duden',
      }),
    );

    if (response.statusCode == 201) {
      // Cadastro bem-sucedido
      print('Usuário cadastrado com sucesso');
    } else {
      // Falha no cadastro
      print('Falha no cadastro: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cadastrarUsuario(); // Chama a função de cadastrar
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CadastroEventoPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeEventoController = TextEditingController();
  final TextEditingController _descricaoEventoController = TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _dataFimController = TextEditingController();

  Future<void> cadastrarEvento() async {
    final String nomeEvento = _nomeEventoController.text;
    final String descricaoEvento = _descricaoEventoController.text;
    final String dataInicio = _dataInicioController.text;
    final String dataFim = _dataFimController.text;

    final url = Uri.parse(
        'http://127.0.0.1:8000/eventos/api/eventos/'); // Substitua pela URL da sua API

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': nomeEvento,
        'descricao': descricaoEvento,
        'data_inicio': dataInicio, // Verifique o formato da data
        'data_fim': dataFim,       // Verifique o formato da data
        'organizador': '1',        // Substitua pelo organizador correto se for dinâmico
      }),
    );

    if (response.statusCode == 201) {  // Sucesso deve ser 201 para criação de novo recurso
      print('Evento cadastrado com sucesso');
    } else {
      print('Falha no cadastro do evento: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Evento'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeEventoController,
                decoration: InputDecoration(labelText: 'Nome do Evento'),
              ),
              TextFormField(
                controller: _descricaoEventoController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _dataInicioController,
                decoration: InputDecoration(labelText: 'Data de Início (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _dataFimController,
                decoration: InputDecoration(labelText: 'Data de Fim (YYYY-MM-DD)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cadastrarEvento(); // Chama a função de cadastrar evento
                  }
                },
                child: Text('Cadastrar Evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CreditosPage extends StatelessWidget {
  final TextEditingController _valorCreditoController = TextEditingController();
  final String _usuarioId = '1'; // Defina o ID do usuário (pegue dinamicamente)
  final String _eventoId = '1'; // Defina o ID do evento (pegue dinamicamente)

  Future<void> adicionarCreditos(BuildContext context) async {
    final String valorCredito = _valorCreditoController.text;

    final url = Uri.parse(
        'http://127.0.0.1:8000/credits/api/transacoes/'); // Substitua pela URL da sua API

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': _usuarioId, 
        'evento': _eventoId, 
        'tipo': 'RECARGA', 
        'valor': valorCredito, 
      }),
    );

    if (response.statusCode == 201) {
      // Sucesso na criação da transação (HTTP 201 Created)
      print('Créditos adicionados com sucesso');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Créditos adicionados com sucesso!')),
      );
    } else {
      print('Falha ao adicionar créditos: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao adicionar créditos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créditos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Saldo Atual: R\$100,00', style: TextStyle(fontSize: 24)),
            TextFormField(
              controller: _valorCreditoController,
              decoration: InputDecoration(labelText: 'Valor dos Créditos'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                adicionarCreditos(context); // Passa o `context` como parâmetro
              },
              child: Text('Adicionar Créditos'),
            ),
          ],
        ),
      ),
    );
  }
}