import 'package:api_local_db/core/app_size.dart';
import 'package:api_local_db/core/app_string.dart';
import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:api_local_db/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel mProductModel;
  const ProductDetails({Key? key, required this.mProductModel})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var dbHelper;
  CartModel mCartModel = CartModel();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    dbHelper = DbHelper();
    await dbHelper.getCartProduct(widget.mProductModel.id).then((cartData) {
      if (cartData != null && cartData.cartId != null) {
        setState(() {
          mCartModel = cartData;
        });
      } else {
        setState(() {
          mCartModel = CartModel();
        });
      }
    });
  }

  int selectQty = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,

        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.mainSize16),
          child: Column(
            children: [
              const SizedBox(
                height: AppSize.mainSize16,
              ),
              Container(
                height: AppSize.mainSize300,
                alignment: Alignment.center,
                child: Image.network(
                  widget.mProductModel.image!,
                ),
              ),
              const SizedBox(
                height: AppSize.mainSize30,
              ),
              const SizedBox(
                height: AppSize.mainSize31,
              ),
              Text(
                widget.mProductModel.title!,
                style: const TextStyle(
                    fontSize: AppSize.mainSize16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: AppSize.mainSize14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: AppSize.mainSize46,
                    width: AppSize.mainSize177,
                    child: ElevatedButton(
                        onPressed: () {
                          if (mCartModel.id != null) {
                          } else {}
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) => Colors.deepPurple,
                          ),
                        ),
                        child: const Text(AppString.textAddToCart)),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSize.mainSize15,
              ),
              const SizedBox(
                height: AppSize.mainSize28,
              ),
              if (mCartModel.id == null)
                Row(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppString.textSelectQty,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: AppSize.mainSize16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: AppSize.mainSize12,
                    ),
                    Row(
                      children: [
                        Container(
                          height: AppSize.mainSize40,
                          width: AppSize.mainSize110,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.circular(AppSize.mainSize5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (selectQty != 0)
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectQty--;
                                      });
                                    },
                                    child: const Icon(Icons.remove)),
                              if (selectQty != 0)
                                const VerticalDivider(
                                  color: Colors.grey,
                                  thickness: AppSize.mainSize1,
                                ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: AppSize.mainSize3),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.mainSize3,
                                    vertical: AppSize.mainSize2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSize.mainSize3),
                                    color: Colors.white),
                                child: Text(
                                  selectQty.toString(),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectQty++;
                                    });
                                  },
                                  child: const Icon(Icons.add)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: AppSize.mainSize73,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete_outlined)),
                      ],
                    ),
                  ],
                ),
              const SizedBox(
                height: AppSize.mainSize5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.mProductModel.description!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: AppSize.mainSize16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: AppSize.mainSize21,
              ),
              const SizedBox(
                height: AppSize.mainSize110,
              )
            ],
          ),
        ),
      ),
    );
  }
}
