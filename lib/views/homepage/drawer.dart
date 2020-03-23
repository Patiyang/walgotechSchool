import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new UserAccountsDrawerHeader(
          accountName: Text(
            'Kratos',
          ),
          accountEmail: Text(
            'patiyang6@gmail.com',
          ),
           currentAccountPicture: GestureDetector(
            child: new CircleAvatar(
              backgroundImage: AssetImage('images/student.jpg'),
            ),
          ),
        )
      ],
    );
  }
}
