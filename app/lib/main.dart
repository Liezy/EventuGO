import 'package:app/src/pages/home_page.dart';
import 'package:app/src/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/pages/auth/sign_in.dart';
import 'src/pages/home_page.dart'; // Importe sua página inicial

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // Verifica o status do futuro
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto aguarda, pode mostrar um carregamento
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            // Se o usuário estiver autenticado, mostra a home
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');
    return userUid != null; // Retorna true se o UID existe
  }
}
