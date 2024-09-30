import 'package:flutter/material.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/cadastro_usuario_page.dart';
import 'package:app/pages/manage_events/manage_events.dart';
import 'package:app/pages/creditos_page.dart';
import 'package:app/pages/transacao_qr_page.dart'; // Adicionei a importação da nova página
import 'package:app/pages/consulta_saldo_historico_page.dart';

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
          ManageEventsPage(), // Tela de Cadastro de Evento
          CreditosPage(), // Tela de Créditos
          TransacaoQrPage(), // Nova Tela de Transação com QR Code
          ConsultaSaldoHistoricoPage(), // Tela de consulta de saldo e histórico
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
            label: 'Gerenciar Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Créditos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code', // Novo item no menu para QR Code
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Consulta', // Novo item para a tela de consulta
          ),
        ],
      ),
    );
  }
}
