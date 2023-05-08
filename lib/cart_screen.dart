import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var dbHelper;
  ProductModel mCartModel = ProductModel();
  void initData() async {
    dbHelper = DbHelper();
    await dbHelper
        .getCartProduct(widget.mProductModel.productId)
        .then((cartData) {
      if (cartData != null && cartData.cartId != null) {
        setState(() {
          mCartModel = cartData;
        });
      } else {
        setState(() {
          mCartModel = ProductModel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
