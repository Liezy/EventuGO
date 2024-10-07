import 'package:flutter/material.dart';
import 'package:app/src/admin/home.dart'; // Importa a Home do Admin
import 'package:app/src/admin/manage_events/manage_events.dart'; // Exemplo de página adicional
import 'package:app/src/admin/qr_code_scan.dart'; // Exemplo de página adicional

class AdminLayout extends StatefulWidget {
  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeAdminPage(),
    ManageEventsPage(),
    QrCodeScanPage(),
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
            icon: Icon(Icons.event),
            label: 'Gerenciar Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Escanear QR Code',
          ),
        ],
      ),
    );
  }
}
