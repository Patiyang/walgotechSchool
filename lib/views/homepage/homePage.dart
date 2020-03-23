import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import 'package:walgotech_final/styling.dart';

import 'carousel.dart';
import 'customdivider.dart';
import 'modules.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(17.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/student.jpg'),
            ),
          ),
          title: Text(widget.title),
          // automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            )
          ],
        ),
        // drawer: new Drawer(
        //   child: DrawerItems(),
        // ),
        body: Column(
          children: <Widget>[
            ImageCarousel(),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'images/student.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(color: accentColor.withOpacity(.5)),
                  ),
                  Modules()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
