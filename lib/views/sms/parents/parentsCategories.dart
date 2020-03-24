import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/views/sms/parents/parentsHistory.dart';
import '../../../styling.dart';

class ParentsCategory extends StatefulWidget {
  @override
  _ParentsCategoryState createState() => _ParentsCategoryState();
}

class _ParentsCategoryState extends State<ParentsCategory> {
  final ContactsManager _contactsManager = ContactsManager();
  SMS sms;
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];
  List<Contacts> contactsList;
  static final individual = 'Individual Contacts';
  static final allParents = 'All Parents';
  static final form1 = 'Form1';
  static final form2 = 'Form2';
  static final form3 = 'Form3';
  static final form4 = 'form4';

//drop down variables
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<String> parentsCategories = <String>[
    'Individual Contacts',
    'All Parents',
    'Form4',
    'Form3',
    'Form2',
    'Form1',
  ];
  String _currentCategory = 'category';
  void initState() {
    _currentCategory = allParents;
    print(parentsCategories);
    super.initState();
    categoriesDropDown = _getCategoriesDropDown();
    _getCategories();
    changeSelectedCategory(_currentCategory);
  }

  @override
  Widget build(BuildContext context) {
    var selectedContacts;
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                          FutureBuilder(
                            future: _contactsManager.getAllContacts(),
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
                                            Contacts contacts = contactsList[index];

                                            return Text(contacts.motherNumber +
                                                "," +
                                                contacts.motherNumber +
                                                "," +
                                                contacts.guardianNumber);
                                          },
                                        ),
                                      );
                              }
                              return Loading();
                            },
                          ),
                          if (_currentCategory == form1)
                          FutureBuilder(
                            future: _contactsManager.getFormOne(),
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
                                            Contacts contacts = contactsList[index];
                                            return Text('{$contacts}');
                                          },
                                        ),
                                      );
                              }
                              return Loading();
                            },
                          ),
                          // if (_currentCategory == form2)
                          // FutureBuilder(
                          //   future: _contactsManager.getFormTwo(),
                          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                          //     if (snapshot.hasData) {
                          //       contactsList = snapshot.data;
                          //       return _currentCategory == individual
                          //           ? TextFormField(
                          //               maxLines: 6,
                          //               controller: recipentController,
                          //               validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                          //               decoration: InputDecoration(
                          //                 enabled: true,
                          //                 hintText: 'Type in Message',
                          //                 border: OutlineInputBorder(),
                          //               ),
                          //             )
                          //           : Container(
                          //               decoration: BoxDecoration(border: Border.all()),
                          //               height: 150,
                          //               child: ListView.builder(
                          //                 physics: BouncingScrollPhysics(),
                          //                 shrinkWrap: true,
                          //                 itemCount: contactsList == null ? 0 : contactsList.length,
                          //                 itemBuilder: (BuildContext context, int index) {
                          //                   Contacts contacts = contactsList[index];
                          //                   return Text('{$contacts}');
                          //                 },
                          //               ),
                          //             );
                          //     }
                          //     return Loading();
                          //   },
                          // ),
                          // if (_currentCategory == form3)
                          // FutureBuilder(
                          //   future: _contactsManager.getFormThree(),
                          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                          //     if (snapshot.hasData) {
                          //       contactsList = snapshot.data;
                          //       return _currentCategory == individual
                          //           ? TextFormField(
                          //               maxLines: 6,
                          //               controller: recipentController,
                          //               validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                          //               decoration: InputDecoration(
                          //                 enabled: true,
                          //                 hintText: 'Type in Message',
                          //                 border: OutlineInputBorder(),
                          //               ),
                          //             )
                          //           : Container(
                          //               decoration: BoxDecoration(border: Border.all()),
                          //               height: 150,
                          //               child: ListView.builder(
                          //                 physics: BouncingScrollPhysics(),
                          //                 shrinkWrap: true,
                          //                 itemCount: contactsList == null ? 0 : contactsList.length,
                          //                 itemBuilder: (BuildContext context, int index) {
                          //                   Contacts contacts = contactsList[index];
                          //                   return Text('{$contacts}');
                          //                 },
                          //               ),
                          //             );
                          //     }
                          //     return Loading();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    if (_currentCategory == form4)
                      FutureBuilder(
                        future: _contactsManager.getFormFour(),
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
                                        Contacts contacts = contactsList[index];
                                        return Text('{$contacts}');
                                      },
                                    ),
                                  );
                          }
                          return Loading();
                        },
                      ),
                    MaterialButton(
                        elevation: 0,
                        color: accentColor,
                        child: Text(
                          'Send to both parents',
                          style: categoriesStyle,
                        ),
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          setState(() {});
                        }),
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
                    MaterialButton(
                      color: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      minWidth: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        'Delete',
                        style: categoriesStyle,
                      ),
                      onPressed: () {
                        delete();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ParentHistory()));
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
      ),
    );
  }

  void saveContacts(BuildContext context) async {
    Client client = Client();
    final ContactsManager _contactsManager = new ContactsManager();

    String url = 'http://10.0.2.2:8000/backend/operations/readAll.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['contacts'].length; i++) {
        Contacts contacts = new Contacts(
          fatherNumber: result['contacts'][i]['fatherphone'],
          motherNumber: result['contacts'][i]['motherphone'],
          guardianNumber: result['contacts'][i]['guardianphone'],
          form: result['contacts'][i]['form'],
        );
        print(contacts.form);
        _contactsManager.addContacts(contacts).then((contact) => print('$contact has been added'));
      }
    } else {
      throw Exception('unable to add contact');
    }
  }

  void delete() {
    final ContactsManager _contactsManager = new ContactsManager();
    _contactsManager.deleteAll();
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
            {messageController.clear(), recipentController.clear(), print('Student added to DB $id')});
      }
    }
  }

  List<DropdownMenuItem<String>> _getCategoriesDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = new List();
    print(parentsCategories.length);
    for (int i = 0; i < parentsCategories.length; i++) {
      setState(() {
        if (parentsCategories.length == 0 || categoriesStyle == null) {
          Text('Absent');
        }
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(parentsCategories[i]),
              value: parentsCategories[i],
            ));
      });
    }
    return dropDownItems;
  }

  _getCategories() async {
    setState(() {
      categoriesDropDown = _getCategoriesDropDown();
      _currentCategory = parentsCategories[0];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
      print(_currentCategory);
    });
  }
}
