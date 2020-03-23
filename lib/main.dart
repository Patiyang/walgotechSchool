import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';

import 'views/homepage/homePage.dart';

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
        scaffoldBackgroundColor: Colors.white
      ),
      home: HomePage(title: 'School Name'),
    );
  }
}
