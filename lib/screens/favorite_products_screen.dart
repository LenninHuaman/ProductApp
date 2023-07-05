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

  loadMeals() async {
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
    loadMeals();
    super.initState();
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
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    product.isFavorite = !product.isFavorite;
                  });
                },
              ),
              ),
            );
          }),
    );
  }
}
