import 'package:app/src/pages/auth/sign_in.dart';
import 'package:app/src/pages/home/entrar_qrcode.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onQrCodeButtonPressed() {
    // Aqui você pode adicionar a ação que deseja realizar ao pressionar o botão
    print('Botão QR Code pressionado!');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventEntryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../../assets/static/image.png', // Verifique este caminho
              width: 300, // Largura da imagem
              height: 300, // Altura da imagem
            ),
            SizedBox(height: 20), // Espaço entre a imagem e o texto
            Text(
              'Boas Vindas ao EventuGo!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(
            top: 100.0), // Margem inferior para empurrar o botão para cima
        child: FloatingActionButton(
          onPressed: _onQrCodeButtonPressed, // Chama a função ao pressionar
          backgroundColor: Colors.white, // Cor de fundo do botão
          foregroundColor: Colors.black, // Cor do ícone do botão
          child: Icon(Icons.qr_code), // Ícone de QR code
          shape: RoundedRectangleBorder(
            // Define a forma como um círculo
            borderRadius: BorderRadius.circular(30), // Raio do círculo
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .startTop, // Localização do botão flutuante
    );
  }
}
