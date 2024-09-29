import 'package:flutter/material.dart';
import 'package:app/pages/main_page.dart'; // Importa a MainPage

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
