import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _uuid = '';
  Map<String, dynamic>? _userData;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  bool _isEditing = false;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carregar dados do usuário ao inicializar a tela
  Future<void> _loadUserData() async {
    _uuid = await _storage.read(key: 'user_uuid') ?? '';
    print('User UUID: $_uuid');

    if (_uuid.isNotEmpty) {
      final token = await _storage.read(key: 'access_token') ?? '';
      if (token.isNotEmpty) {
        final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/users/api/usuarios/$_uuid/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            _userData = json.decode(response.body);
            _firstNameController.text = _userData?['first_name'] ?? '';
            _lastNameController.text = _userData?['last_name'] ?? '';
            _emailController.text = _userData?['email'] ?? '';
            _phoneController.text = _userData?['phone'] ?? '';
            _addressController.text = _userData?['address'] ?? '';
            _birthDateController.text = _userData?['birth_date'] ?? '';
          });
        } else {
          print('Erro ao buscar dados do usuário: ${response.statusCode}');
        }
      }
    }
  }

  // Função para salvar os dados do usuário após edição
  Future<void> _saveUserData() async {
    final Map<String, String> dataToSave = {};

    if (_firstNameController.text.isNotEmpty) {
      dataToSave['first_name'] = _firstNameController.text;
    }
    if (_lastNameController.text.isNotEmpty) {
      dataToSave['last_name'] = _lastNameController.text;
    }
    if (_emailController.text.isNotEmpty) {
      dataToSave['email'] = _emailController.text;
    }
    if (_phoneController.text.isNotEmpty) {
      dataToSave['phone'] = _phoneController.text;
    }
    if (_addressController.text.isNotEmpty) {
      dataToSave['address'] = _addressController.text;
    }
    if (_birthDateController.text.isNotEmpty) {
      dataToSave['birth_date'] = _birthDateController.text;
    }

    if (dataToSave.isNotEmpty) {
      final token = await _storage.read(key: 'access_token') ?? '';
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/users/api/usuarios/$_uuid/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dataToSave),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados salvos com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar dados: ${response.statusCode}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum dado para salvar!')),
      );
    }
  }

  // Alterna entre modo de edição e modo de visualização
  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _saveUserData();
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuário'),
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        '${_userData!['first_name'][0]}${_userData!['last_name'][0]}',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _firstNameController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _lastNameController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(labelText: 'Sobrenome'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(labelText: 'Telefone'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      readOnly: !_isEditing,
                      decoration: InputDecoration(labelText: 'Endereço'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _birthDateController,
                      readOnly: !_isEditing,
                      decoration:
                          InputDecoration(labelText: 'Data de Nascimento'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _toggleEdit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_isEditing ? Icons.save : Icons.edit),
                          SizedBox(width: 8),
                          Text(_isEditing ? 'Salvar' : 'Editar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
