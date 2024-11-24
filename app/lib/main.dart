import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/pages/auth/sign_in.dart';
import 'src/pages/home/home_page.dart';
import 'src/pages/main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Certifique-se de ter essa importação

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventuGo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Adicionando os localizationsDelegates corretamente
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, // Se você usar componentes Cupertino
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pt', 'BR'),
      ],
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // Verifica o status do futuro
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto aguarda, pode mostrar um carregamento
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            // Se o usuário estiver autenticado, mostra a página principal
            return MainPage();
          } else {
            // Caso contrário, mostra a página de login
            return SignInPage();
          }
        },
      ),
    );
  }

  // Função para verificar se o usuário está autenticado
  Future<bool> _checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userUid = prefs.getString('user_uid');
      return userUid != null; // Retorna true se o UID existe
    } catch (e) {
      print('Erro ao verificar login status: $e');
      return false; // Caso ocorra um erro, consideramos o usuário não autenticado
    }
  }
}
