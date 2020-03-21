import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:walgotech_final/homepage/drawer.dart';
import 'package:walgotech_final/styling.dart';

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
    Widget carousel = new Container(
      height: 140,
      color: primaryColor,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          Image.asset('images/C1.jpg')
        ],
        dotBgColor: Colors.transparent,
        indicatorBgPadding: 5,
        overlayShadow: false,
        borderRadius: false,
        dotSize: 5,
        animationCurve: Curves.easeOutQuart,
        autoplay: false,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
    return Scaffold(
      appBar: AppBar(
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
      drawer:new Drawer(child: DrawerItems(),) ,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          carousel,

        ],
      ),
    );
  }
}
