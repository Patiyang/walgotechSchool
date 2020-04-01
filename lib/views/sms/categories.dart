import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/sms/parents/Mesaging.dart';
import 'package:walgotech_final/views/sms/parents/messageHistory.dart';
import 'package:walgotech_final/views/sms/settings/settings.dart';
import 'package:walgotech_final/views/sms/subordinateStaff/subordinatecategory.dart';

class AllContactCategories extends StatefulWidget {
  @override
  _AllContactCategoriesState createState() => _AllContactCategoriesState();
}

class _AllContactCategoriesState extends State<AllContactCategories> {
  String bal;

  int page = 0;
  final barKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    getUserBalance();
    page = 0;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
        actions: <Widget>[
          Center(
              child: Text(
            'Balance: $bal',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ))
        ],
        elevation: .7,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Hero(
              tag: 'contacts',
              child: CircleAvatar(
                backgroundImage: AssetImage('images/modules/msg.jpg'),
              )),
        ),
        title: Stack(
          children: <Widget>[
            Visibility(visible: page == 0, child: Text('Create Message')),
            Visibility(visible: page == 1, child: Text('Your History')),
            Visibility(visible: page == 2, child: Text('Schedule Message')),
            Visibility(visible: page == 3, child: Text('Settings')),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: customBtns,
        key: barKey,
        animationDuration: Duration(milliseconds: 150),
        index: 0,
        height: 45,
        animationCurve: Curves.easeInOut,
        buttonBackgroundColor: customBtns,
        backgroundColor: primaryColor,
        items: <Widget>[
          Icon(Icons.face, size: 19, color: Colors.black),
          Icon(Icons.message, size: 19, color: Colors.black),
          Icon(Icons.timer, size: 19, color: Colors.black),
          Icon(Icons.settings, size: 19, color: Colors.black)
        ],
        onTap: (index) {
          debugPrint('current index is $index');
          setState(() {
            page = index;
          });
        },
      ),
      body: page == 0
          ? Messaging()
          : Container(
              child: page == 1 ? MessageHistory() : Container(child: page == 2 ? Schedule() : Settings()),
            ),
    );
  }

  getUserBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('balance');
  }
}
