import 'package:calculator/app/calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff22252D),
        accentColor: Color(0xff22252D)
      ),
      debugShowCheckedModeBanner: false,
      home: CalculatorApp(),
    );
  }
}