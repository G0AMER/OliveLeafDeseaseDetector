import 'package:flutter/material.dart';
import 'package:stage_app/home.dart';
import 'methods.dart';

void main() {
  runApp(const MyApp1());
}
//to create widget==to create class

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    print(context);
    checkRememberedCredentials(context);
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
