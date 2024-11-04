import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart'; // Certifique-se de que o CartProvider está no caminho correto
import 'cart_page.dart'; // Importar a página do carrinho

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> produto;

  ProductDetailPage({required this.produto});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(produto['name'] ?? 'Detalhes do Produto'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                produto['name'] ?? 'Nome do Produto',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Preço: R\$ ${produto['value'].toString()}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.blueGrey[200]),
            SizedBox(height: 10),
            _buildDetailRow(Icons.description, 'Descrição', produto['description'] ?? 'Sem descrição'),
            SizedBox(height: 10),
            _buildDetailRow(Icons.inventory, 'Estoque', produto['qtd_stock'].toString()),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Adiciona o produto ao carrinho
                  cartProvider.addProduct(
                    Product(
                      name: produto['name'],
                      price: double.parse(produto['value'].toString()), // Converte para double
                      description: produto['description'],
                      // Adicionar outros atributos necessários, como id ou quantidade
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${produto['name']} adicionado ao carrinho!')),
                  );
                },
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Adicionar ao Carrinho'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueGrey[600]),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
