import 'package:app/src/pages/events/listagem_eventos.dart';
import 'package:app/src/pages/profile/perfil_usuario.dart';
import 'package:flutter/material.dart';
import 'package:app/src/pages/home/home_page.dart';
import 'package:app/src/pages/auth/sign_up.dart';
import 'package:app/src/pages/rotas_wip/manage_events/manage_events.dart';
import 'package:app/src/pages/rotas_wip/creditos_page.dart';
import 'package:app/src/pages/events/transacao_qr_page.dart'; // Importa o gerador de qr code
import 'package:app/src/pages/consulta_saldo_historico_page.dart';
import 'package:app/src/pages/qr_code_scan.dart'; // Importa o scanner
import 'package:app/src/pages/auth/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid'); // Remove o UUID salvo
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SignInPage(), // Redireciona para a página de login
      ),
    );
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
          UserEventsPage(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70, // Aumenta a altura do BottomNavigationBar
        child: BottomNavigationBar(
          backgroundColor: Colors.white, // Cor de fundo do BottomNavigationBar
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.purple[700],
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
      ),
    );
  }
}
