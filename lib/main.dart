import 'package:api_local_db/db/navigator_key.dart';
import 'package:api_local_db/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        navigatorKey: NavigatorKey.navigatorKey,
        home: const HomeScreen());
  }
}
