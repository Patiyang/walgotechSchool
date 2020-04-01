import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Color primaryColor = new Color(0xffffffff);
Color accentColor = new Color(0xff303030);

 TextStyle modules=new TextStyle(color: primaryColor, fontSize: 20);
 TextStyle categoriesStyle = modules.copyWith(fontSize: 14,letterSpacing: .6);



var orange = Colors.orange;
TextStyle categoryTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontFamily: 'Sans',
  fontWeight: FontWeight.bold,
  letterSpacing: .63,
);


TextStyle fadedTextStyle = TextStyle(
  color: Colors.white70,
  fontWeight: FontWeight.bold,
  fontSize: 19,
  fontFamily: 'Sans',
  letterSpacing: .6,
);

TextStyle heading = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 30,
  fontFamily: 'Sans',
  letterSpacing: .6,
);

TextStyle register = TextStyle(
  fontSize: 30,
  color: accentColor,
  
  letterSpacing: .5,
);

TextStyle signIn = TextStyle(
  fontSize: 20,
  color: accentColor,
  fontFamily: 'Sans',
  letterSpacing: .5,
);
