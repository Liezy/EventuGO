import 'dart:convert';
import 'package:app/src/pages/auth/sign_up.dart';
import 'package:app/src/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'access_token', value: token);
    print('Token salvo com sucesso: $token');
  }

  Future<void> saveUserInfo(Map<String, dynamic> userData) async {
    await storage.write(
        key: 'user_uuid', value: userData['uid']); // Ajustado para 'uid'
    await storage.write(key: 'user_name', value: userData['first_name']);
    await storage.write(key: 'user_email', value: userData['email']);
    print('Informações do usuário salvas: $userData');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> fetchUserInfo(String token) async {
    final url = Uri.parse('http://127.0.0.1:8000/users/api/current-user/');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Informações do usuário recebidas: $data');
        await saveUserInfo(data);
      } else {
        print('Erro ao buscar informações do usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar informações do usuário: $e');
    }
  }

  Future<void> loginUsuario(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('http://127.0.0.1:8000/users/token/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access'];
        print('Login bem-sucedido! Token recebido: $token');

        await saveToken(token);
        await fetchUserInfo(token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login bem-sucedido!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou senha inválidos.')),
        );
      } else {
        print('Erro na requisição: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao conectar ao servidor.')),
        );
      }
    } catch (e) {
      print('Erro ao tentar fazer login: $e');
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/static/image.png',
                  width: 150,
                  height: 150,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um email válido';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Insira um email válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
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
                      await loginUsuario(context);
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                Text('Não tem uma conta?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Cadastre-se',
                    style: TextStyle(color: Colors.blue),
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
