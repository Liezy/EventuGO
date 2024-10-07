import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(TextEditingController controller, String label,
    {Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 10.0), // Aumenta a distância entre os campos
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(), // Estilo retangular
        filled: true,
        fillColor: Colors.white,
      ),
      readOnly: onTap != null,
      onTap: onTap,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[\u00C0-\u00FFa-zA-Z0-9 ]"))
      ],
    ),
  );
}
