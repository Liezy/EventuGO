import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../components/action_button.dart'; // Importando o botão de ação
import '../../components/text_field.dart'; // Importando o campo de texto

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeEventoController = TextEditingController();
  final TextEditingController _descricaoEventoController =
      TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _dataFimController = TextEditingController();
  final TextEditingController _horaFimController = TextEditingController();

  Future<void> cadastrarEvento() async {
    final String nomeEvento = _nomeEventoController.text;
    final String descricaoEvento = _descricaoEventoController.text;
    final String dataInicio =
        '${_dataInicioController.text} ${_horaInicioController.text}';
    final String dataFim =
        '${_dataFimController.text} ${_horaFimController.text}';

    final url = Uri.parse('http://127.0.0.1:8000/event/api/eventos/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': nomeEvento,
        'description': descricaoEvento,
        'type': '1',
        'start_date': dataInicio,
        'end_date': dataFim,
        'company': '1',
      }),
    );

    void _showSnackBar(String message) {
      final snackBar = SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Tempo que o SnackBar ficará visível
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (response.statusCode == 201) {
      print('Evento cadastrado com sucesso');
      _showSnackBar('Evento criado com sucesso!');
      Navigator.pop(context);
    } else {
      print('Falha no cadastro do evento: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale("pt", "BR"), // Define o locale para português
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd')
          .format(picked); // Formata a data como YYYY-MM-DD
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = "$hour:$minute"; // Formata a hora como HH:mm
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Você tem certeza que deseja criar este evento?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                cadastrarEvento(); // Chama a função de cadastrar o evento
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(_nomeEventoController, 'Nome do Evento'),
              buildTextField(_descricaoEventoController, 'Descrição'),
              buildTextField(
                _dataInicioController,
                'Data de Início',
                onTap: () => _selectDate(_dataInicioController),
              ),
              buildTextField(
                _horaInicioController,
                'Hora de Início',
                onTap: () => _selectTime(_horaInicioController),
              ),
              buildTextField(
                _dataFimController,
                'Data de Fim',
                onTap: () => _selectDate(_dataFimController),
              ),
              buildTextField(
                _horaFimController,
                'Hora de Fim',
                onTap: () => _selectTime(_horaFimController),
              ),
              SizedBox(height: 20),
              buildActionButton(
                'Cadastrar Evento',
                Colors.green,
                Colors.white,
                Icons.add,
                () {
                  if (_formKey.currentState!.validate()) {
                    _showConfirmationDialog(); // Exibe o diálogo de confirmação
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
