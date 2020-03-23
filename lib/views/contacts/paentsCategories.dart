import 'package:flutter/material.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/contacts/SMS.dart';

class ParentsCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
              child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                height: 50,
                color: Colors.white54,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                    Text('Update Contacts')
                  ],
                ),
                onPressed: () {
                  updateContacts();
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:8.0),
                  child: Container(color: Colors.black,height: 70,),
                ),
                MessageModule()
          ],
        ),
      ),
    );
  }

  void updateContacts() {}
}
