import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        backgroundColor: Colors.blueGrey,
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text('Seu carrinho está vazio!'))
          : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Preço: R\$ ${item.price} x ${item.quantity}'),
                  trailing: Text('Total: R\$ ${(item.price * item.quantity).toStringAsFixed(2)}'),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: R\$ ${cartProvider.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: cartProvider.cartItems.isEmpty
                  ? null
                  : () async {
                      final userId = "seu_user_id_aqui"; // Substitua pelo ID do usuário
                      await cartProvider.processPurchase(userId);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Compra Concluída'),
                          content: Text('Sua compra foi processada com sucesso!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Finalizar Compra',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
