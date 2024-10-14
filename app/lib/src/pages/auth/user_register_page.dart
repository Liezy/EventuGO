import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroUsuarioPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> cadastrarUsuario() async {
    final String nome = _nomeController.text;
    final String sobrenome = _sobrenomeController.text;
    final String cpf = _cpfController.text;
    final String email = _emailController.text;
    final String telefone = _telefoneController.text;
    final String endereco = _enderecoController.text;
    final String nascimento = _nascimentoController.text;
    final String senha = _senhaController.text;

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
        'user_type': 1, // Tipo de usuário (Cliente, por padrão)
      }),
    );

    if (response.statusCode == 201) {
      print('Usuário cadastrado com sucesso');
    } else {
      print('Falha no cadastro: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: _sobrenomeController,
                  decoration: InputDecoration(labelText: 'Sobrenome'),
                ),
                TextFormField(
                  controller: _cpfController,
                  decoration: InputDecoration(labelText: 'CPF'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _telefoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                ),
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(labelText: 'Endereço'),
                ),
                TextFormField(
                  controller: _nascimentoController,
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      cadastrarUsuario();
                    }
                  },
                  child: Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
