import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(TextEditingController controller, String label,
    {Function()? onTap, bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      readOnly: onTap != null,
      onTap: onTap,
      obscureText: isPassword,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[\u00C0-\u00FFa-zA-Z0-9 ]"))
      ],
    ),
  );
}
