import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/sms/categories.dart';

import 'customdivider.dart';

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
                CircleAvatar(
                  // child: Icon(Icons.message, size: 35, color: accentColor),
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/registration.png'),
                ),
                HorizontalDIvider(),
                Text('Registration & profiles', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/exam.png'),
                ),
                HorizontalDIvider(),
                Text('Exams', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/finance.png'),
                ),
                HorizontalDIvider(),
                Text('Accounts & Finance', style: modules)
              ],
            ),
            CustomDivider(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AllContactCategories()));
              },
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: 'contacts',
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('images/modules/msg.jpg'),
                    ),
                  ),
                  HorizontalDIvider(),
                  Text('SMS/Notifications', style: modules)
                ],
              ),
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/biometrics.png'),
                ),
                HorizontalDIvider(),
                Text('Biometrics', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/payroll.png'),
                ),
                HorizontalDIvider(),
                Text('HR/Payroll', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/tt.png'),
                ),
                HorizontalDIvider(),
                Text('Time Table', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/inventory.jpg'),
                ),
                HorizontalDIvider(),
                Text('Inventory', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/lib.png'),
                ),
                HorizontalDIvider(),
                Text('Library', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/syllabus.png'),
                ),
                HorizontalDIvider(),
                Text('Syllabus/Attendance', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/studentsavings.png'),
                ),
                HorizontalDIvider(),
                Text('Pocket Money/Club Savings', style: modules)
              ],
            ),
            CustomDivider(),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('images/modules/discipline.png'),
                ),
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
