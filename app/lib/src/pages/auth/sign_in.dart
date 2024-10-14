import 'dart:convert';
import 'package:app/src/pages/auth/sign_up.dart';
import 'package:app/src/pages/home/home_page.dart';
import 'package:app/src/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final String _senhaEstatica = ''; // Senha estática

  Future<void> saveUidLocally(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
  }

  Future<void> loginUsuario(BuildContext context) async {
    final String email = _emailController.text;
    final url = Uri.parse('http://127.0.0.1:8000/users/api/usuarios/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        final user = users.firstWhere((user) => user['email'] == email,
            orElse: () => null);

        if (user != null) {
          final String uid = user['uid'];
          await saveUidLocally(uid);
          print('Login bem-sucedido. UID: $uid');

          // Exibir Snackbar de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login bem-sucedido!')),
          );

          // Navega para MainPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else {
          print('Email não encontrado.');

          // Exibir Snackbar de erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email não encontrado.')),
          );
        }
      } else {
        print('Falha na requisição: ${response.statusCode}');

        // Exibir Snackbar de erro na requisição
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao conectar ao servidor.')),
        );
      }
    } catch (e) {
      print('Erro ao tentar fazer o login: $e');

      // Exibir Snackbar de erro na exceção
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao tentar fazer login.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 128.0), // Padding nas laterais
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Alinhamento vertical
              children: [
                Image.asset(
                  '../../assets/static/image.png', // Verifique este caminho
                  width: 150, // Largura da imagem
                  height: 150, // Altura da imagem
                ),
                // Campo de email com validação
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um email válido';
                    }
                    // Validação adicional para formato de email
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Insira um email válido';
                    }
                    return null;
                  },
                ),
                // Campo de senha estática
                TextFormField(
                  initialValue: _senhaEstatica,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira uma senha válida';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await loginUsuario(context); // Realiza o login
                    }
                  },
                  child: Text('Login'),
                ),

                SizedBox(height: 20),
                // Link para a página de cadastro
                Text('Não tem uma conta?'),
                TextButton(
                  onPressed: () {
                    // Navega para a página de cadastro
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Cadastre-se',
                    style: TextStyle(color: Colors.blue), // Estilo do link
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
