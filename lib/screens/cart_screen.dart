import 'dart:convert';

import 'package:api_local_db/apiProvider/api_provider.dart';
import 'package:api_local_db/core/app_size.dart';
import 'package:api_local_db/core/app_string.dart';
import 'package:api_local_db/core/app_url.dart';
import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final ProductModel mProductModel;
  const CartScreen({Key? key, required this.mProductModel}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late DbHelper dbHelper;
  List<CartModel> mCartModel = [];
  @override
  void initState() {
    // initCartData();
    super.initState();
  }
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

/*
  addToCart() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    CartModel cModel = CartModel();

    cModel.cartProductId = widget.mProductModel.productId;
    cModel.cartProductQty = selectQty;
    cModel.cartUserId = sp.getInt(AppConfig.textUserId);

    if (selectQty != 0) {
      dbHelper = DbHelper();
      await dbHelper.saveCartData(cModel).then((cartData) {
        alertDialog("Successfully Added");
      }).catchError((error) {
        alertDialog("Error: Data Save Fail--$error");
      });
      initData();
    } else {
      alertDialog("Please Select Qty");
    }
    dbHelper = DbHelper();
    await dbHelper.saveCartData(cModel).then((productData) {
      widget.onProductAddToCart();
    }).catchError((error) {
      alertDialog("Error: Data Save Fail--$error");
    });
  }
*/

/*  void saveCartData() async {
    CartModel cModel = mCartModel;

    dbHelper = DbHelper();
    await dbHelper.saveCartData(cModel).then((cartData) {
      */
  /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CartScreen()));*/ /*
    }).catchError((error) {});
    setState(() {});
  }*/

  ///Add to Cart
  initCartData() async {
    var response = await ApiProvider().postMethod(UrlProvider.apiCartUrl);
    mCartModel = List<CartModel>.from(
        jsonDecode(response).map((model) => CartModel.fromJson(model)));
    setState(() {});
    print('CartUSerId----> ${mCartModel.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSize.mainSize16),
        child: SizedBox(
            height: AppSize.mainSize45,
            child: ElevatedButton(
                onPressed: () {}, child: const Text(AppString.textCheckout))),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.mainSize16),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  /*
                  CartModel item = mCartModel[index];*/
                  return Container(
                    margin: const EdgeInsets.all(AppSize.mainSize10),
                    padding: const EdgeInsets.all(AppSize.mainSize10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: AppSize.mainSize5,
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppSize.mainSize20))),
                    child: Row(
                      children: [
                        Image.network(
                            height: AppSize.mainSize100,
                            width: AppSize.mainSize100,
                            widget.mProductModel.image!),
                        const SizedBox(
                          width: AppSize.mainSize10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.mProductModel.title!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: AppSize.mainSize10,
                              ),
                              Text(widget.mProductModel.description!),
                              SizedBox(
                                height: AppSize.mainSize10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.mProductModel.price!.toString(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              /*ListView.builder(
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
                  }),*/
            ),
          ],
        ),
      ),
    );
  }
}
