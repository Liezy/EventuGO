import 'package:flutter/material.dart';
import 'package:app/src/admin/layout.dart'; // Importa a Home para Admin
import 'package:app/src/client/layout.dart'; // Importa a Home para Cliente

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha a Interface'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdminLayout()), // Navega para a Home Admin
                );
              },
              child: Text('Admin'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),

            // Adicionar Botão para cliente
          ],
        ),
      ),
    );
  }
}
