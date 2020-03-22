import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: Container(
        height: 40,
        width: 1,
        color: Colors.white,
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
      ),
    );
  }
}



class HorizontalDIvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: 30,
      color: Colors.white,
    );
  }
}
