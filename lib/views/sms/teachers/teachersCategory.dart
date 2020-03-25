import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/views/sms/teachers/teachersHistory.dart';
import '../../../styling.dart';

class TeachersCategory extends StatefulWidget {
  @override
  _TeachersCategoryState createState() => _TeachersCategoryState();
}

class _TeachersCategoryState extends State<TeachersCategory> {
  final TeacherManager _teacherManager = TeacherManager();
  SMS sms;
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];
  List<TeacherContacts> contactsList;
  static final individual = 'Individual Contacts';
  static final allTeachers = 'All Teachers';

//drop down variables
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<String> teachersCategories = <String>[
    'Individual Teachers',
    'All Teachers',
  ];
  String _currentCategory = 'category';
  void initState() {
    _currentCategory = allTeachers;
    print(teachersCategories);
    super.initState();
    categoriesDropDown = _getCategoriesDropDown();
    _getCategories();
    changeSelectedCategory(_currentCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Material(color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
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
                  saveContacts(context);
                }),

            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Material(
                        elevation: 0,
                        color: Colors.black26,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.black26,
                            ),
                            hint: Text('Select Category'),
                            items: categoriesDropDown,
                            onChanged: changeSelectedCategory,
                            value: _currentCategory,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        Visibility(
                          visible: _currentCategory == allTeachers,
                          child: FutureBuilder(
                            future: _teacherManager.getAllContacts(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                contactsList = snapshot.data;
                                return _currentCategory == individual
                                    ? TextFormField(
                                        maxLines: 6,
                                        controller: recipentController,
                                        validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                                        decoration: InputDecoration(
                                          enabled: true,
                                          hintText: 'Type in Message',
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(border: Border.all()),
                                        height: 150,
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: contactsList == null ? 0 : contactsList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            TeacherContacts contacts = contactsList[index];

                                            return Text(contacts.phoneNumber);
                                          },
                                        ),
                                      );
                              }
                              return Loading();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 6,
                      controller: recipentController,
                      validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                      decoration: InputDecoration(
                        enabled: true,
                        hintText: 'Type in Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    minWidth: MediaQuery.of(context).size.width * .6,
                    child: Text(
                      'send',
                      style: categoriesStyle,
                    ),
                    onPressed: () {
                      sendMessage(context);
                    },
                  ),
                  // MaterialButton(
                  //   color: accentColor,
                  //   elevation: 0,
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  //   minWidth: MediaQuery.of(context).size.width * .6,
                  //   child: Text(
                  //     'Delete',
                  //     style: categoriesStyle,
                  //   ),
                  //   onPressed: () {
                  //     delete();
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MaterialButton(
                      color: accentColor,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      minWidth: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        'View History',
                        style: categoriesStyle,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => TeachersHistory()));
                      },
                    ),
                  ),
                ],
              ),
            )
            // SendMessage()
          ],
        ),
      ),
    );
  }

  void saveContacts(BuildContext context) async {
    Client client = Client();
    final TeacherManager _contactsManager = new TeacherManager();
// String url = 'http://192.168.100.10:8000/backend/operations/readAll.php';
    String url = 'http://192.168.100.10:8000/backend/operations/readAllTeachers.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['teachers'].length; i++) {
        TeacherContacts contacts = new TeacherContacts(
          phoneNumber: result['teachers'][i]['phone'],
          firstName: result['teachers'][i]['firstName'],
          lastName: result['teachers'][i]['lastName'],
        );
        print(contacts.firstName);
        _contactsManager.addContacts(contacts).then((contact) => print('$contact has been added'));
      }
    } else {
      throw Exception('unable to add contact');
    }
  }

  void delete() {
    final TeacherManager teacherManager = new TeacherManager();
    teacherManager.getAllContacts();
  }

  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text,
          sender: recipentController.text,
          recipent: _currentCategory,
          dateTime: DateTime.now().toString(),
        );
        _smsManager.insertSMS(sms).then((id) =>
            {messageController.clear(), recipentController.clear(), print('message added to DB $id')});
      }
    }
  }

  List<DropdownMenuItem<String>> _getCategoriesDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = new List();
    print(teachersCategories.length);
    for (int i = 0; i < teachersCategories.length; i++) {
      setState(() {
        if (teachersCategories.length == 0 || categoriesStyle == null) {
          Text('Absent');
        }
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(teachersCategories[i]),
              value: teachersCategories[i],
            ));
      });
    }
    return dropDownItems;
  }

  _getCategories() async {
    setState(() {
      categoriesDropDown = _getCategoriesDropDown();
      _currentCategory = teachersCategories[0];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
      print(_currentCategory);
    });
  }
}
