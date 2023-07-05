import 'package:product_app/data/model/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class DbHelper {
  final int _version = 1;
  final String _databaseName = 'products.db';
  final String _tableName = 'products';

  Database? _db;

  Future<Database> openDb() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        db.execute('create table $_tableName (id INTEGER PRIMARY KEY, title TEXT,  description TEXT, price INTEGER, stock INTEGER, thumbnail TEXT)');
      //
      },
      version: _version,
    );
    return _db as Database;
  }

  insert(Product product) async {
    await _db?.insert(_tableName, product.toMap());
  }

  delete(Product product) async {
    await _db?.delete(_tableName, where: 'id=?', whereArgs: [product.id]);
  }

  Future<bool> isFavorite(Product product) async {
    final maps =
        await _db?.query(_tableName, where: 'id=?', whereArgs: [product.id]);
    return maps!.isNotEmpty;
  }

  Future<List<Product>> fetchAll() async {
    final maps = await _db?.query(_tableName);
    if (maps != null) {
      List<Product> products = maps.map((map) => Product.fromMap(map)).toList();
      return products;
    } else {
      return [];
    }
  }
}