import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../components/action_button.dart'; // Importando o botão
import '../../components/text_field.dart'; // Importando o campo de texto

class UpdateEventPage extends StatefulWidget {
  final int eventId; // ID do evento a ser atualizado

  UpdateEventPage({required this.eventId});

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeEventoController = TextEditingController();
  final TextEditingController _descricaoEventoController =
      TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _dataFimController = TextEditingController();
  final TextEditingController _horaFimController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  Future<void> fetchEventDetails() async {
    final url =
        Uri.parse('http://127.0.0.1:8000/event/api/eventos/${widget.eventId}/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final event = jsonDecode(response.body);
      _nomeEventoController.text = event['name'];
      _descricaoEventoController.text = event['description'];

      // Separar data e hora corretamente
      DateTime startDate = DateTime.parse(event['start_date']);
      DateTime endDate = DateTime.parse(event['end_date']);

      _dataInicioController.text =
          DateFormat('yyyy-MM-dd').format(startDate); // Apenas a data
      _horaInicioController.text =
          DateFormat('HH:mm').format(startDate); // Apenas a hora
      _dataFimController.text =
          DateFormat('yyyy-MM-dd').format(endDate); // Apenas a data
      _horaFimController.text =
          DateFormat('HH:mm').format(endDate); // Apenas a hora
    } else {
      print('Erro ao carregar evento: ${response.statusCode}');
    }
  }

  Future<void> atualizarEvento() async {
    final String nomeEvento = _nomeEventoController.text;
    final String descricaoEvento = _descricaoEventoController.text;

    // Montar as datas para o formato esperado pela API
    final DateTime dataInicio = DateTime.parse(
      '${_dataInicioController.text} ${_horaInicioController.text}',
    );
    final DateTime dataFim = DateTime.parse(
      '${_dataFimController.text} ${_horaFimController.text}',
    );

    final String startDateFormatted =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(dataInicio.toUtc());
    final String endDateFormatted =
        DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(dataFim.toUtc());

    final url =
        Uri.parse('http://127.0.0.1:8000/event/api/eventos/${widget.eventId}/');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': nomeEvento,
        'description': descricaoEvento,
        'start_date': startDateFormatted, // Usando o formato correto
        'end_date': endDateFormatted, // Usando o formato correto
        'company': '1', // Empresa fixa para o exemplo
        'type': '1', // Tipo fixo para o exemplo
      }),
    );

    if (response.statusCode == 200) {
      print('Evento atualizado com sucesso');
      _showSnackBar('Evento atualizado com sucesso!'); // Exibe o SnackBar
      Navigator.pop(context);
    } else {
      print('Falha na atualização do evento: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  Future<void> deletarEvento() async {
    final url =
        Uri.parse('http://127.0.0.1:8000/event/api/eventos/${widget.eventId}/');

    final response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Evento excluído com sucesso');
      _showSnackBar('Evento excluído com sucesso!'); // Exibe o SnackBar
      Navigator.pop(context);
    } else {
      print('Falha na exclusão do evento: ${response.statusCode}');
      print('Erro detalhado: ${response.body}');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2), // Tempo que o SnackBar ficará visível
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Você tem certeza que deseja excluir este evento?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                deletarEvento(); // Chama a função de exclusão
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Excluir'),
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
        title: Text('Atualizar Evento'),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildActionButton(
                    'Atualizar',
                    Colors.blue,
                    Colors.white,
                    Icons.update,
                    () {
                      if (_formKey.currentState!.validate()) {
                        atualizarEvento();
                      }
                    },
                  ),
                  SizedBox(
                      width: 20), // Adicionando espaçamento entre os botões
                  buildActionButton(
                    'Excluir',
                    Colors.red,
                    Colors.white,
                    Icons.delete,
                    () {
                      // Chama a função de confirmação de exclusão
                      _showDeleteConfirmation();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
