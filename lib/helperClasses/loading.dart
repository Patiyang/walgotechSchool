import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:primaryColor,
      child: CircularProgressIndicator(),
    );
  }
}