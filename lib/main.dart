import 'package:flutter/material.dart';
import 'package:walgotech_final/homepage/homePage.dart';
import 'package:walgotech_final/styling.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
      ),
      home: HomePage(title: 'Irene'),
    );
  }
}
