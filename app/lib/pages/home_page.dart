import 'package:flutter/material.dart';
import 'package:app/pages/qr_code_scan.dart'; // página de QR Code Scan

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo à Home Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Espaçamento entre o texto e o botão
            ElevatedButton(
              onPressed: () {
                // Navega para a página de escaneamento de QR Code
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrCodeScanPage(), // Página de scan
                  ),
                );
              },
              child: Text('Escanear QR Code'),
            ),
          ],        ),
      ),
    );
  }
}