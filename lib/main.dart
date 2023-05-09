import 'dart:convert';

import 'package:api_local_db/apiProvider/api_provider.dart';
import 'package:api_local_db/db/db_helper.dart';
import 'package:api_local_db/model/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fake Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Fake Store API'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ProductModel> mProductModel = [];
  late DbHelper dbHelper;

  @override
  void initState() {
    initData();

    dbHelper = DbHelper();
    super.initState();
  }

  void initData() async {
    var response = await ApiProvider()
        .getMethod('https://fakestoreapi.com/products/category/electronics');
    mProductModel = List<ProductModel>.from(
        jsonDecode(response).map((model) => ProductModel.fromJson(model)));

    for (int i = 0; i < mProductModel.length; i++) {
      saveApiData(i);
    }
    setState(() {
      print('Length ---------> ${mProductModel.length}');
    });
  }

  void saveApiData(int index) async {
    ProductModel pModel = mProductModel[index];

    dbHelper = DbHelper();
    await dbHelper.saveData(pModel).then((productData) {
      print("Successfully Saved");

/*      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CartScreen()));*/
    }).catchError((error) {
      print("Error: Data Save Fail--$error");
    });
    setState(() {
      print("Model Item--------------> ${pModel.image}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          /*elevation: 0,*/
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            ProductModel item = mProductModel[index];
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Row(
                children: [
                  Image.network(
                    item.image!,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(item.description!),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.price!.toString(),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // saveApiData();
                            },
                            child: const Text('Save Data')),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: mProductModel.length,
        ));
  }
}
