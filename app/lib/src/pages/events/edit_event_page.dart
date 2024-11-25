import 'dart:html' as html; // Para manipular arquivos
import 'package:flutter/material.dart';

class EditEventPage extends StatefulWidget {
  final int eventId;

  EditEventPage({required this.eventId});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  String? _uploadedImageUrl; // Para armazenar a URL da imagem carregada

  void _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final html.File? file = uploadInput.files?.first;

      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) {
          setState(() {
            _uploadedImageUrl = reader.result as String?;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Escolher Imagem'),
            ),
            SizedBox(height: 16),
            if (_uploadedImageUrl != null)
              Image.network(
                _uploadedImageUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Text('Nenhuma imagem selecionada'),
          ],
        ),
      ),
    );
  }
}
