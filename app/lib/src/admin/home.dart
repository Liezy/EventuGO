import 'package:flutter/material.dart';

class HomeAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Bem-vindo, Administrador!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../../assets/images/eventugo.png', // Caminho da imagem
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Bem-vindo ao Eventugo, Admin!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
