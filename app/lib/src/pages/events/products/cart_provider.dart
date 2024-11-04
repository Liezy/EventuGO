import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String description;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.name == product.name);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _cartItems.removeWhere((item) => item.name == product.name);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
  }

  Future<void> processPurchase(String userId) async {
    // Simula o processo de compra (poderia incluir lógica de API aqui)
    await Future.delayed(Duration(seconds: 2)); // Simulação de tempo de processamento

    // Após a conclusão da compra, limpa o carrinho
    clearCart();
  }
}
