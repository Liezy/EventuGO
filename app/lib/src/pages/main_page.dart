import 'package:flutter/material.dart';
import 'package:app/src/pages/home_page.dart';
import 'package:app/src/pages/auth/user_register_page.dart';
import 'package:app/src/pages/manage_events/manage_events.dart';
import 'package:app/src/pages/creditos_page.dart';
import 'package:app/src/pages/transacao_qr_page.dart'; // Importa o gerador de qr code
import 'package:app/src/pages/consulta_saldo_historico_page.dart';
import 'package:app/src/pages/qr_code_scan.dart'; // Importa o scanner
import 'package:app/src/pages/auth/login_page.dart';

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
          HomePage(),
          LoginPage(),
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
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
