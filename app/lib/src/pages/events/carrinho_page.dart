import 'package:flutter/material.dart';

class CarrinhoPage extends StatelessWidget {
  final List<dynamic> produtosNoCarrinho;

  CarrinhoPage({required this.produtosNoCarrinho});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
      ),
      body: produtosNoCarrinho.isEmpty
          ? Center(
              child: Text(
                'Seu carrinho está vazio!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: produtosNoCarrinho.length,
              itemBuilder: (context, index) {
                final produto = produtosNoCarrinho[index];
                return ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text(produto['name'] ?? 'Nome indisponível'),
                  subtitle: Text(
                      'Preço: R\$ ${(double.tryParse(produto['value']) ?? 0.0).toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Remover produto do carrinho
                      produtosNoCarrinho.removeAt(index);
                      // Atualizar estado
                      (context as Element).markNeedsBuild();
                    },
                  ),
                );
              },
            ),
    );
  }
}
