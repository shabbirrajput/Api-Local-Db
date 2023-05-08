import 'package:api_local_db/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DbHelper {
  late Database _db;

  static const String dbName = 'Product.db';
  static const String tableProduct = 'Product';
  static const int version = 1;

  static const String productId = 'id';
  static const String title = 'title';
  static const String price = 'price';
  static const String description = 'description';
  static const String image = 'image';
  static const String cartProductID = 'cartProductID';
  static const String tableCart = 'tableCart';

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $tableProduct ("
        "$productId INTEGER PRIMARY KEY,"
        "$title TEXT,"
        "$price TEXT,"
        "$description TEXT,"
        "$image TEXT"
        ")");

    await db.execute("CREATE TABLE $tableCart ("
        " $cartProductID INTEGER PRIMARY KEY,"
        "$title TEXT,"
        "$price TEXT,"
        "$description TEXT,"
        "$image TEXT"
        ")");
  }

  ///Insert Data
  Future<int> saveData(ProductModel product) async {
    var dbClient = await db;
    var res = await dbClient.insert(tableProduct, product.toJson());
    return res;
  }

  ///GetCartData
  Future<ProductModel> getCartProduct(int productId) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableCart WHERE "
        "$cartProductID = $productId ");

/*    if (res.isNotEmpty) {
      return CartModel.fromJson(res.first);
    }*/
    return ProductModel();
  }
}
