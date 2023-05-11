import 'package:api_local_db/core/app_size.dart';
import 'package:api_local_db/core/app_string.dart';
import 'package:api_local_db/db/com_helper.dart';
import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:api_local_db/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel mProductModel;
  final Function onProductAddToCart;
  const ProductDetails(
      {Key? key, required this.mProductModel, required this.onProductAddToCart})
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
  int userId = 5;

  addToCart() async {
    CartModel cModel = CartModel();

    cModel.id = widget.mProductModel.id;
    cModel.userId = 5;

    if (userId == 5) {
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
    await dbHelper.saveProductData(cModel).then((productData) {
      widget.onProductAddToCart();
    }).catchError((error) {
      alertDialog("Error: Data Save Fail--$error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*const Text(
                AppString.textProductDetail,
                style: TextStyle(
                  color: AppColor.colorWhite,
                  fontFamily: AppFonts.avenirRegular,
                  fontSize: AppSize.mainSize18,
                  fontWeight: FontWeight.w900,
                ),
              ),*/
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(mProductModel: null,),
                  ),
                );*/
              },
            ),
          ],
        ),
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
                height: 30,
              ),
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImage.appHS1),
                    Image.asset(AppImage.appHS2),
                    Image.asset(AppImage.appHS3),
                  ],
                ),*/
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
                    width: 177,
                    child: ElevatedButton(
                        onPressed: () {
                          /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(mProductModel: null,),
                  ),
                );*/

                          /*initData();*/
                          /* if (mCartModel.id != null) {
                            */ /*removeFromCart();*/ /*
                          } else {
                            addToCart();
                          }*/
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) => Colors.deepPurple,
                          ),
                        ),
                        child: const Text('Add To Cart')

                        /*Text(
                          mCartModel.cartId != null
                              ? 'Remove From Cart'
                              : AppString.textAddToCart,
                          style: const TextStyle(
                            color: AppColor.colorWhite_two,
                            fontFamily: AppFonts.avenirRegular,
                          ),
                        ),*/
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSize.mainSize15,
              ),
              /*const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppString.textHSPrice,
                    style: TextStyle(
                      color: AppColor.colorPrimary_two,
                      fontSize: AppSize.mainSize24,
                      fontFamily: AppFonts.avenirRegular,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),*/
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
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
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
                                  thickness: 1,
                                ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white),
                                child: Text(
                                  selectQty.toString(),
                                ),
                              ),
                              /* if (selectQty !=
                                    widget.mProductModel.!)
                                  const VerticalDivider(
                                    color: AppColor.colorCoolGrey,
                                    thickness: 1,
                                  ),
                                if (selectQty !=
                                    widget.mProductModel.productQty!)*/
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
              /* const SizedBox(
                  height: AppSize.mainSize31,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppString.textProductDetail,
                    style: TextStyle(
                      color: AppColor.colorBlack_two,
                      fontSize: AppSize.mainSize16,
                      fontFamily: AppFonts.avenirRegular,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),*/
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
