import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_local_db/apiProvider/api_provider.dart';
import 'package:api_local_db/core/app_size.dart';
import 'package:api_local_db/core/app_string.dart';
import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/screens/cart_screen.dart';
import 'package:api_local_db/core/app_url.dart';
import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*CartModel mCartModel = CartModel();*/
  List<CartModel> mCartModel = [];

  List<ProductModel> mProductModel = [];
  late DbHelper dbHelper;
  StreamSubscription? internetconnection;
  bool isoffline = false;

  @override
  void initState() {
    initData();
    // initNewData();
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // when every connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    });
    dbHelper = DbHelper();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  void initData() async {
    var response = await ApiProvider().getMethod(UrlProvider.apiUrl);
    mProductModel = List<ProductModel>.from(
        jsonDecode(response).map((model) => ProductModel.fromJson(model)));

    for (int i = 0; i < mProductModel.length; i++) {
      saveApiData(i);
    }

    ///Internet connection checker
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    setState(() {});
  }

  void saveApiData(int index) async {
    ProductModel pModel = mProductModel[index];

    dbHelper = DbHelper();
    await dbHelper.saveData(pModel).then((productData) {
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CartScreen()));*/
    }).catchError((error) {});
    setState(() {});
  }

  int selectQty = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart_outlined))
        ],
        backgroundColor: Colors.deepPurpleAccent,
        /*elevation: 0,*/
      ),
      body: FutureBuilder<List>(
        future: dbHelper.getAllRecords(),
        initialData: const [],
        builder: (context, snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        child: errMsg(
                            AppString.textNoInternetConnectionAvailable,
                            isoffline),
                        //to show internet connection message on isoffline = true.
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, int position) {
                          final item = snapshot.data![position];
                          //get your item data here ...
                          return Container(
                            margin: const EdgeInsets.all(AppSize.mainSize10),
                            padding: const EdgeInsets.all(AppSize.mainSize10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 5,
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.mainSize20))),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  height: AppSize.mainSize100,
                                  width: AppSize.mainSize100,
                                  imageUrl: item.row[4],
                                ),
                                const SizedBox(
                                  width: AppSize.mainSize10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.row[1],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: AppSize.mainSize10,
                                      ),
                                      Text(item.row[3]),
                                      const SizedBox(
                                        height: AppSize.mainSize10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.row[2],
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            initData();
                                          },
                                          child: const Text(
                                              AppString.textAddToCart)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Widget errMsg(String text, bool show) {
    //error message widget.
    if (show == true) {
      //if error is true then show error message box
      return Container(
        padding: const EdgeInsets.all(AppSize.mainSize10),
        margin: const EdgeInsets.only(bottom: AppSize.mainSize10),
        color: Colors.red,
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(right: AppSize.mainSize6),
            child: const Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text(text, style: const TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
    } else {
      return Container();
      //if error is false, return empty container.
    }
  }
}
