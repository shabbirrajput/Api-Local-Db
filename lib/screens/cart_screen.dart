import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late DbHelper dbHelper;
  ProductModel mCartModel = ProductModel();
/*  void initData() async {
    dbHelper = DbHelper();
    await dbHelper
        .getCartProduct(
        widget.mProductModel.productId)
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
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Image.network(
                          'https://blogger.googleusercontent.com/img/a/AVvXsEj3QuTZS9GDUmW8x5PIhoBEBFGwOoq_B_N6DqaqA46m3458WZti_XpROAMuZtX4Dm772GtZ6-Y3-9jZSgqgwdmURlNLP0PMSynGpQ3uGfvz-zrEbXF2KYd4TQsMhqd-QM807v1A1gSx8Rr8tqYF7AJD297pGjEc5m3yoM60d-CDd9fMIbX-ooBccIXMAQ',
                          height: 100,
                          width: 100,
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
