import 'dart:convert';

import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/model/cart_product_model.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

class DbHelper {
  late Database _db;

  static const String dbName = 'product.db';
  static const String tableProduct = 'Product';
  static const int version = 6;

  ///Product Table
  static const String productId = 'id';
  static const String title = 'title';
  static const String price = 'price';
  static const String description = 'description';
  static const String image = 'image';
  static const String category = 'category';
  static const String rating = 'rating';

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  ///Database Creation
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    ///Product Table
    await db.execute("CREATE TABLE $tableProduct ("
        "$productId INTEGER PRIMARY KEY,"
        "$title TEXT,"
        "$price TEXT,"
        "$description TEXT,"
        "$image TEXT"
        ")");
  }

  ///Insert Into Product Table
  Future<int> saveData(ProductModel product) async {
    var dbClient = await db;
    var res = await dbClient.insert(tableProduct, product.toJson());
    return res;
  }

  ///Get Data From Products Table
  Future<List> getAllRecords() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableProduct");

    return result.toList();
  }

  ///Fetch Data From API and Local DB

  Future<List<CartModel>> fetchCart() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/carts'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => CartModel(
                id: json['id'],
                userId: json['userId'],
                date: json['date'],
                /*products: json['products'],*/
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<ProductModel>> fetchProd() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery('''SELECT * FROM $tableProduct''');
    List<ProductModel> product = [];
    for (var map in maps) {
      ProductModel prod = ProductModel(
        id: map['id'],
        title: map['title'],
        price: map['price'],
        description: map['description'],
        image: map['image'],
      );
      product.add(prod);
    }
    return product;
  }

  Future<List<CartProductModel>> getJoinedData() async {
    List<CartModel> mCartModel = await fetchCart();
    List<ProductModel> mProductModel = await fetchProd();
    List<CartProductModel> mCartProdModel = [];

    for (var apiCart in mCartModel) {
      ProductModel? dbBook =
          mProductModel.firstWhere((book) => book.id == apiCart.id);
      CartProductModel book = CartProductModel(
        id: apiCart.id!,
        title: dbBook.title,
        /* price: dbBook.price!,*/
        description: dbBook.description,
        image: dbBook.image,
        cartUserId: apiCart.userId,
        cartDate: apiCart.date,
        /*products: apiCart.products,*/
      );
      mCartProdModel.add(book);
    }
    return mCartProdModel;
  }
}
