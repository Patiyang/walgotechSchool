import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: primaryColor,
      child: Carousel(
        boxFit: BoxFit.fitWidth,
        images: [
          Container(
              child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '10th\nApril\n2020',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 65.0),
                      child: Text(
                        'Anual General Meeting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'The scheduled date for the annual general meeting is to be respected and everyone shound show up ',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
          // Image.asset('images/C1.jpg', fit: BoxFit.cover),
          // Image.asset('images/C2.jpg', fit: BoxFit.cover),
          // Image.asset('images/C3.jpg', fit: BoxFit.cover),
          // Image.asset('images/C4.jpg', fit: BoxFit.cover),
          // Image.asset('images/C5.jpg', fit: BoxFit.cover),
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
  }
}
