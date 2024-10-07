import 'package:flutter/material.dart';

Widget buildActionButton(String text, Color backgroundColor, Color textColor,
    IconData icon, VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      foregroundColor: textColor,
      backgroundColor: backgroundColor, // Define a cor do texto
      textStyle: TextStyle(fontSize: 16), // Define o tamanho da fonte
    ),
    icon: Icon(icon), // Adiciona o ícone
    label: Text(text), // Adiciona o texto
  );
}
