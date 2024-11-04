import 'package:app/src/pages/home/home_page.dart';
import 'package:app/src/pages/main_page.dart';
import 'package:app/src/pages/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/pages/events/products/cart_provider.dart'; // Certifique-se de criar e importar o CartProvider corretamente

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Meu App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return MainPage();
            } else {
              return SignInPage();
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString('user_uid');
    return userUid != null;
  }
}
