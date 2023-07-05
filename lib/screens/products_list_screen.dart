import 'package:flutter/material.dart';
import 'package:product_app/data/remote/product_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductService? productService;
  List? productList;
  bool isFavorite = false;

  initialize() async {
    final result = await productService?.getProducts();
    setState(() {
      productList = result!;
    });
  }
  
  @override
  void initState() {
    productService = ProductService();
    productList = List.empty();
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
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
            ),
          );
        }
      ),
    );
  }
}