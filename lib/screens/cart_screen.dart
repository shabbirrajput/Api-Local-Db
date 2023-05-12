import 'package:api_local_db/core/app_size.dart';
import 'package:api_local_db/core/app_string.dart';
import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/cart_model.dart';
import 'package:api_local_db/model/cart_product_model.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late DbHelper dbHelper;
  List<CartModel> mCartModel = [];

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
              child: FutureBuilder<List<CartProductModel>>(
                future: DbHelper().getJoinedData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        print("-------${snapshot.data![index].title}");
                        return Padding(
                          padding: const EdgeInsets.all(AppSize.mainSize8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: AppSize.mainSize3,
                                  color: Colors.black),
                              borderRadius:
                                  BorderRadius.circular(AppSize.mainSize8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.mainSize10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: AppSize.mainSize70,
                                    width: AppSize.mainSize70,
                                    child: Image.network(
                                      "${snapshot.data![index].image}",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppSize.mainSize10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: AppSize.mainSize10,
                                        ),
                                        Text(
                                            "ID : ${snapshot.data![index].id}"),
                                        const SizedBox(
                                          height: AppSize.mainSize10,
                                        ),
                                        Text(
                                            "User ID : ${snapshot.data![index].cartUserId}"),
                                        const SizedBox(
                                          height: AppSize.mainSize10,
                                        ),
                                        Text("${snapshot.data![index].title}"),
                                        const SizedBox(
                                          height: AppSize.mainSize10,
                                        ),
                                        Text(
                                            "Date : ${snapshot.data![index].cartDate}"),
                                        const SizedBox(
                                          height: AppSize.mainSize20,
                                        ),
                                        Row(
                                          children: const [
                                            SizedBox(
                                              width: AppSize.mainSize20,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
