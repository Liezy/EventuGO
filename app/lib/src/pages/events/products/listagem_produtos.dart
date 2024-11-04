import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/src/pages/events/products/product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> _produtos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/event/api/produtos/'));

    if (response.statusCode == 200) {
      setState(() {
        _produtos = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      print('Erro ao buscar produtos: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos')),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _produtos.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum produto encontrado',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(produto: produto),
                          ),
                        );// Aqui você pode navegar para uma tela de detalhes do produto
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.shopping_bag, size: 40),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produto['name'],
                                        style: TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        produto['description'] ?? 'Sem descrição',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Preço: R\$ ${produto['value'].toString()}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.blueGrey),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Estoque: ${produto['qtd_stock'].toString()}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
