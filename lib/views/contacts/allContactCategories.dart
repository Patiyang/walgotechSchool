import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/contacts/formOne.dart';

class AllContactCategories extends StatefulWidget {
  @override
  _AllContactCategoriesState createState() => _AllContactCategoriesState();
}

class _AllContactCategoriesState extends State<AllContactCategories> {
  int page = 0;
  final barKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // var _selectedIndex;
    return Scaffold(
      appBar: AppBar(
        elevation: .7,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Hero(
              tag: 'contacts',
              child: CircleAvatar(
                backgroundImage: AssetImage('images/modules/msg.jpg'),
              )),
        ),
        title: Text('SMS Categories'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        // color: p,
        key: barKey,
        animationDuration: Duration(milliseconds: 150),
        index: 1,
        height: 45,
        animationCurve: Curves.easeInOut,
        buttonBackgroundColor: Colors.white,
        backgroundColor: primaryColor,
        items: <Widget>[
          Icon(Icons.face, size: 19),
          Icon(Icons.people, size: 19),
          Icon(Icons.group_work, size: 19)
        ],
        onTap: (index) {
          debugPrint('current index is $index');
          setState(() {
            page=index;
          });
        },
      ),
      body: Container(
        child:page==0? Column(
          children: <Widget>[
            Center(child: Text(page.toString())),
            RaisedButton(onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (_)=>FormOne()));
            }),
          ],
        ):Container(
          child: page==1?Container(child: Text('parents widget'),):Container(child: Text('dcdcdc'),),
        )
      ),
    );
  }
}
