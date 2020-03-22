import 'package:flutter/material.dart';
import 'package:walgotech_final/homepage/customdivider.dart';
import 'package:walgotech_final/styling.dart';

class Modules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(child: Icon(Icons.message, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Registration & profiles', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Exams', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Accounts & Finance', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('SMS/Notifications', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Biometrics', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('HR/Payroll', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Time Table', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Inventory', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Library', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Syllabus/Attendance', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Pocket Money/Club Savings', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                    child: Icon(Icons.library_books, size: 35, color: accentColor), radius: 35, backgroundColor: primaryColor),
                HorizontalDIvider(),
                Text('Student Behaviour', style: modules)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
