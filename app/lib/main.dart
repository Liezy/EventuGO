import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/app.dart'; // Importa o novo arquivo 'app.dart'

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Eventos e Créditos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Colors.white, // Define o fundo branco globalmente
      ),
      home: AppPage(), // Tela principal agora é AppPage
      localizationsDelegates: [
        GlobalMaterialLocalizations
            .delegate, // Suporte a localizações do Material
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', ''), // Suporte para o português
      ],
    );
  }
}
