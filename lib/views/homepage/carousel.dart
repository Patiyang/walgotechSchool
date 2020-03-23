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
          Image.asset('images/C1.jpg', fit: BoxFit.cover),
          Image.asset('images/C2.jpg', fit: BoxFit.cover),
          Image.asset('images/C3.jpg', fit: BoxFit.cover),
          Image.asset('images/C4.jpg', fit: BoxFit.cover),
          Image.asset('images/C5.jpg', fit: BoxFit.cover),
        ],
        dotBgColor: Colors.transparent,
        indicatorBgPadding: 5,
        overlayShadow: false,
        borderRadius: false,
        dotSize: 5,
        animationCurve: Curves.easeOutQuart,
        autoplay: true,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
  }
}
