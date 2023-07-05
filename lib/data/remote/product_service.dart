import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:product_app/data/model/product.dart';

class ProductService {
  final urlBase = 'https://dummyjson.com/products';

  Future<List?> getProducts() async {
    final result = await http.get(Uri.parse(urlBase));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = jsonDecode(result.body);
      final maps = jsonResponse['products'];
      return maps.map((map) => Product.fromJson(map)).toList();
    }
    else {
      return null;
    }
  }

}