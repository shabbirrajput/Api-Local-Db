import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
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

  ///Cart Table
  static const String tableCart = 'Cart';
  static const String cartId = 'cartId';
  static const String cartProductID = 'cartProductID';
  static const String cartProductQty = 'cartProductQty';
  static const String cartUserId = 'cartUserId';

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

    ///Cart Table
    await db.execute("CREATE TABLE $tableCart ("
        " $cartId INTEGER PRIMARY KEY,"
        "$cartProductID INTEGER,"
        "$cartProductQty INTEGER,"
        "$cartUserId INTEGER"
        ")");
  }

  ///Create Product Table
  Future<int> saveData(ProductModel product) async {
    var dbClient = await db;
    var res = await dbClient.insert(tableProduct, product.toJson());
    return res;
  }

  ///Create Cart Table
  Future<int> saveCartData(CartModel cart) async {
    var dbClient = await db;
    var res = await dbClient.insert(tableCart, cart.toJson());
    return res;
  }

  ///Get Data From Products Table
  Future<List> getAllRecords() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableProduct");

    return result.toList();
  }

  ///Get Data From Cart Table
  Future<CartModel> getCartProduct(int productId, int userId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableCart WHERE "
        "$cartProductID = $productId AND "
        "$cartUserId = $userId");

    if (res.isNotEmpty) {
      return CartModel.fromJson(res.first);
    }
    return CartModel();
  }

  ///Join Query
  Future<List<CartModel>> getUserCart(int userId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM $tableCart INNER JOIN $tableProduct on $tableProduct.$productId=$tableCart.$cartProductID WHERE $cartUserId = $userId");

    try {
      List<CartModel> mCartModel =
          List<CartModel>.from(res.map((model) => CartModel.fromJson(model)));

      return mCartModel;
    } catch (e) {
      return [];
    }
  }

  Future<List> getAllCartRecords(int userId) async {
    int userId = 5;
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableProduct WHERE $productId=$userId");

    return result.toList();
  }

/*  Future<ProductModel> getCartProduct(int productId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableCart WHERE "
        "$cartProductID = $productId ");

*/ /*    if (res.isNotEmpty) {
      return CartModel.fromJson(res.first);
    }*/ /*
    return ProductModel();
  }*/
}
