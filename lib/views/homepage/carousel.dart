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
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: accentColor)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '10th\nApril\n2020',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 10),
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
            ),
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: accentColor)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '17th\nNovember\n2020',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 60, top: 10),
                        child: Text(
                          'Students Clinic Day',
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
                          'It is Important that every parent shows up on the scheduled date as it will also be the release date for the mock results',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: accentColor)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '18th\nMay\n2020',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 10),
                        child: Text(
                          'Form 3 field trip',
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
                          'On this day, we recommend that you equip your kids with all the necessary equipment',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
