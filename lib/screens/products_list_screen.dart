import 'package:flutter/material.dart';
import 'package:product_app/data/local/bd_helper.dart';
import 'package:product_app/data/remote/product_service.dart';

import '../data/model/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductService? productService;
  List? productList;
  DbHelper? dbHelper;

  initialize() async {
    final result = await productService?.getProducts();
    await dbHelper?.openDb();
    if (result != null) {
      for (final product in result) {
        final isFavorite = await dbHelper?.isFavorite(product);
        if (isFavorite != null) {
          product.isFavorite = isFavorite;
        }
      }
    }
    setState(() {
      productList = result!;
    });
  }
  
  Future<void> toggleFavorite(Product product) async {
    final isFavorite = product.isFavorite;
    if (isFavorite) {
      await dbHelper?.delete(product);
    } else {
      await dbHelper?.insert(product);
    }
    setState(() {
      product.isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    productService = ProductService();
    productList = List.empty();
    dbHelper = DbHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products App"),
      ),
      body: ListView.builder(
        itemCount: productList?.length,
        itemBuilder: (context, index) {
          final product = productList?[index];
          return Card(
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(product.thumbnail),
                  ),
                ),
              ),
              title: Text(product.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.description),
                  const SizedBox(height: 8.0),
                  Text('Price: \$${product.price.toStringAsFixed(2)}'),
                  Text('Stock: ${product.stock}'),
                ],
              ),
              trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: product.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () => toggleFavorite(product),
            ),
            ),
          );
        }
      ),
    );
  }
}