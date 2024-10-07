import 'package:flutter/material.dart';
import 'package:app/src/client/home.dart'; // Importa a Home do Cliente
import 'package:app/src/client/creditos_page.dart'; // Exemplo de página adicional
import 'package:app/src/client/transacao_qr_page.dart'; // Exemplo de página adicional

class ClientLayout extends StatefulWidget {
  @override
  _ClientLayoutState createState() => _ClientLayoutState();
}

class _ClientLayoutState extends State<ClientLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeClientPage(),
    CreditosPage(),
    TransacaoQrPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            bottom: 80, // Acima do BottomNavigationBar
            right: 20, // Canto direito inferior
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // Ação de voltar para a tela anterior
              },
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Créditos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Transação QR',
          ),
        ],
      ),
    );
  }
}