import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SMS.dart';

class ParentsCategory extends StatefulWidget {
  @override
  _ParentsCategoryState createState() => _ParentsCategoryState();
}

class _ParentsCategoryState extends State<ParentsCategory> {
  List<String> _contacts;
  void initState() {
    super.initState();
    // getUserName();
    loadContacts();
    // _userName = '';
    _contacts = [];
  }

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
                  loadContacts();
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                color: Colors.black,
                height: 70,
              ),
            ),
            MessageModule()
          ],
        ),
      ),
    );
  }

  void loadContacts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _contacts = preferences.getStringList('contacts');
    setState(() {
      _contacts = preferences.getStringList('contacts');
      print(_contacts.toString());
    });
  }
}
