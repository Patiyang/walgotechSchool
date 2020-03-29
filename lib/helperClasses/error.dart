import 'package:flutter/material.dart';

class ErrorLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'You encountered an error',
            style: TextStyle(color: Colors.black, fontFamily: 'Sans'),
          ),
        ),
      ),
    );
  }
}
