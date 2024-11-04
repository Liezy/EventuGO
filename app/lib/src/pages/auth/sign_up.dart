import 'dart:convert';
import 'package:app/src/pages/auth/sign_in.dart';
import 'package:app/src/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatelessWidget {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  // Controladores para Etapa 1 (Email e Senha)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Controladores para Etapa 2 (Informações Pessoais)
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();

  // Função para realizar o cadastro de fato
  Future<void> cadastrarUsuario(
    String email,
    String senha,
    String nome,
    String sobrenome,
    String cpf,
    String telefone,
    String endereco,
    String nascimento,
  ) async {
    final url = Uri.parse('http://127.0.0.1:8000/users/api/usuarios/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'first_name': nome,
        'last_name': sobrenome,
        'cpf': cpf,
        'email': email,
        'phone': telefone,
        'address': endereco,
        'birth_date': nascimento,
        'password': senha,
        'user_type': 1,
      }),
    );

    if (response.statusCode == 201) {
      print('Usuário cadastrado com sucesso');
      buscarUidPorEmail(email); // Busca o UID após o cadastro
    } else {
      print('Falha no cadastro: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  Future<void> saveUidLocally(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);
  }

  Future<void> buscarUidPorEmail(String email) async {
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
          print('UID salvo com sucesso: $uid');
        } else {
          print('Usuário não encontrado após cadastro.');
        }
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar UID: $e');
    }
  }

  // Primeira Etapa - Solicita Email e Senha
  Widget buildStep1(BuildContext context) {
    return Form(
      key: _formKeyStep1,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Alinha verticalmente ao centro
        children: [
          Image.asset(
            '../../assets/static/image.png', // Verifique este caminho
            width: 150, // Largura da imagem
            height: 150, // Altura da imagem
          ),
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
          TextFormField(
            controller: _senhaController,
            decoration: InputDecoration(labelText: 'Senha'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Insira uma senha válida';
              }
              // Validação adicional para comprimento mínimo
              if (value.length < 6) {
                return 'A senha deve ter pelo menos 6 caracteres';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKeyStep1.currentState!.validate()) {
                // Após validar, vai para a segunda etapa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Step2Page(
                      email: _emailController.text,
                      senha: _senhaController.text,
                      cadastrarUsuario: cadastrarUsuario,
                    ),
                  ),
                );
              }
            },
            child: Text('Próximo'),
          ),
          SizedBox(height: 20),
          // Link para a página de cadastro
          Text('Já tem uma conta?'),
          TextButton(
            onPressed: () {
              // Navega para a página de cadastro
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text(
              'Faça Login',
              style: TextStyle(color: Colors.blue), // Estilo do link
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 128.0), // Padding lateral ajustado
        child: Center(
          // Centraliza o conteúdo verticalmente
          child: SingleChildScrollView(
            // Adicionado para permitir rolagem se necessário
            child: buildStep1(context),
          ),
        ),
      ),
    );
  }
}

// Segunda Etapa - Informações Pessoais
class Step2Page extends StatelessWidget {
  final String email;
  final String senha;
  final Function cadastrarUsuario;

  final _formKeyStep2 = GlobalKey<FormState>();

  // Controladores para Etapa 2
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();

  Step2Page({
    required this.email,
    required this.senha,
    required this.cadastrarUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 128.0), // Padding lateral ajustado
        child: Center(
          // Centraliza o conteúdo verticalmente
          child: SingleChildScrollView(
            // Adicionado para permitir rolagem se necessário
            child: Form(
              key: _formKeyStep2,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Alinha verticalmente ao centro
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sobrenomeController,
                    decoration: InputDecoration(labelText: 'Sobrenome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu sobrenome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: InputDecoration(labelText: 'CPF'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira um CPF válido';
                      }
                      // Validação adicional para formato de CPF (apenas exemplo simplificado)
                      final cpfRegex =
                          RegExp(r'^\d{11}$'); // CPF deve ter 11 dígitos
                      if (!cpfRegex.hasMatch(value)) {
                        return 'Insira um CPF válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu telefone';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: InputDecoration(labelText: 'Endereço'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu endereço';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nascimentoController,
                    decoration:
                        InputDecoration(labelText: 'Data de Nascimento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua data de nascimento';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKeyStep2.currentState!.validate()) {
                        // Realiza o cadastro
                        cadastrarUsuario(
                          email,
                          senha,
                          _nomeController.text,
                          _sobrenomeController.text,
                          _cpfController.text,
                          _telefoneController.text,
                          _enderecoController.text,
                          _nascimentoController.text,
                        ).then((_) {
                          // Se o cadastro for bem-sucedido, navegue para MainPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        });
                      }
                    },
                    child: Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
