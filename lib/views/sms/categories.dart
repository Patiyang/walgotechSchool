import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/sms/parents/Mesaging.dart';
import 'package:walgotech_final/views/sms/parents/parentsHistory.dart';
import 'package:walgotech_final/views/sms/settings/settings.dart';
import 'package:walgotech_final/views/sms/subordinateStaff/subordinatecategory.dart';

class AllContactCategories extends StatefulWidget {
  @override
  _AllContactCategoriesState createState() => _AllContactCategoriesState();
}

class _AllContactCategoriesState extends State<AllContactCategories> {
  String bal;
  Text balance;
  int page = 0;
  final barKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    page = 0;
  }

  Widget build(BuildContext context) {
    // var _selectedIndex;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        actions: <Widget>[
          Center(
              child: Text(
            'Balance:',
            style: TextStyle(fontSize: 20, color: Colors.green),
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
        
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: accentColor,
        key: barKey,
        animationDuration: Duration(milliseconds: 150),
        index: 0,
        height: 45,
        animationCurve: Curves.easeInOut,
        buttonBackgroundColor: accentColor,
        backgroundColor: primaryColor,
        items: <Widget>[
          Icon(Icons.face, size: 19, color: Colors.white),
          Icon(Icons.people, size: 19, color: Colors.white),
          Icon(Icons.group_work, size: 19, color: Colors.white),
          Icon(Icons.settings, size: 19, color: Colors.white)
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
              child: page == 1 ? ParentHistory() : Container(child: page == 2 ? SubOrdinateCategory() : Settings()),
            ),
    );
  }

  getUserBalance() {}
  checkstringlength() {}
}
