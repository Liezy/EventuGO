import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      localizationsDelegates: [
        GlobalMaterialLocalizations
            .delegate, // Adiciona suporte a localizações do Material
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', ''), // Suporte para o português
      ],
    );
  }
}