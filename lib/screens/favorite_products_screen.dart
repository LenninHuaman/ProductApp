import 'package:flutter/material.dart';
import 'package:product_app/data/local/bd_helper.dart';
import 'package:product_app/data/model/product.dart';


class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  List? productList;
  DbHelper? dbHelper;

  loadProducts() async {
    await dbHelper?.openDb();
    final result = await dbHelper?.fetchAll();
    setState(() {
      productList = result!;
    });
  }

  @override
  void initState() {
    dbHelper = DbHelper();
    productList = List.empty();
    loadProducts();
    super.initState();
  }

  int calculateTotalStock() {
    int totalStock = 0;
    for (Product product in productList!) {
      totalStock += product.stock ?? 0;
    }
    return totalStock;
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (Product product in productList!) {
      totalPrice += product.price ?? 0.0;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: const Icon(Icons.delete),
                onPressed: () {
                  dbHelper?.delete(product);
                  productList!.remove(product);
                  setState(() {
                    product.isFavorite = !product.isFavorite;
                  });
                },
              ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Stock: ${calculateTotalStock()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Total Price: \$${calculateTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Icon(Icons.info),
    ),
    );
  }
}
