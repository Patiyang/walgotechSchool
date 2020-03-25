import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/views/sms/parents/parentsHistory.dart';
import '../../../styling.dart';

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final ParentsContactsManager _contactsManager = ParentsContactsManager();
  Text userName;
  String _userName;
  List<String> classes;
  SMS sms;
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String recipent;
  List<ParentsContacts> contactsList;
  static final individual = 'Individual Contacts';
  static final allParents = 'All Parents';
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<String> parentsCategories;
  String _currentCategory = 'category';
  void initState() {
    _currentCategory = allParents;
    getContactList();
    print(parentsCategories.toString());
    parentsCategories = [individual,allParents];
    super.initState();
    categoriesDropDown = _getCategoriesDropDown();
    _getCategories();
    getUserName();
    changeSelectedCategory(_currentCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
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
                    Visibility(
                        visible: _currentCategory == 'Form1' ||
                            _currentCategory == 'Form1' ||
                            _currentCategory == 'Form3' ||
                            _currentCategory == 'Form4',
                        child: MaterialButton(
                            elevation: 0,
                            color: accentColor,
                            child: Text(
                              'Send to both parents',
                              style: categoriesStyle,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            onPressed: () {
                              setState(() {});
                            })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: <Widget>[
                          Visibility(
                            visible: _currentCategory == allParents,
                            child: FutureBuilder(
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
                                              ParentsContacts contacts = contactsList[index];

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
                          ),
                          Visibility(
                            visible: _currentCategory == 'Form1',
                            child: FutureBuilder(
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
                                              ParentsContacts contacts = contactsList[index];
                                              return Text(contacts.fatherNumber +
                                                  "," +
                                                  contacts.guardianNumber +
                                                  "," +
                                                  contacts.motherNumber);
                                            },
                                          ),
                                        );
                                }
                                return Loading();
                              },
                            ),
                          ),
                          Visibility(
                            visible: _currentCategory == 'Form2',
                            child: FutureBuilder(
                              future: _contactsManager.getFormTwo(),
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
                                              ParentsContacts contacts = contactsList[index];
                                              return Text(contacts.fatherNumber +
                                                  "," +
                                                  contacts.guardianNumber +
                                                  "," +
                                                  contacts.motherNumber);
                                            },
                                          ),
                                        );
                                }
                                return Loading();
                              },
                            ),
                          ),
                          Visibility(
                            visible: _currentCategory == 'Form3',
                            child: FutureBuilder(
                              future: _contactsManager.getFormThree(),
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
                                              ParentsContacts contacts = contactsList[index];
                                              return Text(
                                                  contacts.fatherNumber + contacts.guardianNumber + "," + contacts.motherNumber);
                                            },
                                          ),
                                        );
                                }
                                return Loading();
                              },
                            ),
                          ),
                          Visibility(
                            visible: _currentCategory == 'Form4',
                            child: FutureBuilder(
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
                                              ParentsContacts contacts = contactsList[index];
                                              return Text(contacts.fatherNumber +
                                                  "," +
                                                  contacts.guardianNumber +
                                                  "," +
                                                  contacts.motherNumber);
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
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: MaterialButton(
                    //     color: accentColor,
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    //     minWidth: MediaQuery.of(context).size.width * .6,
                    //     child: Text(
                    //       'View History',
                    //       style: categoriesStyle,
                    //     ),
                    //     onPressed: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (_) => ParentHistory()));
                    //     },
                    //   ),
                    // ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text('Sending: Messages', style: categoryTextStyle.copyWith(color: accentColor, fontSize: 17)),
                              Text(
                                'Sending to: Contacts',
                                style: categoryTextStyle.copyWith(color: accentColor, fontSize: 17),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          color: accentColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          minWidth: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            'Send',
                            style: categoriesStyle,
                          ),
                          onPressed: () {
                            sendMessage(context);
                          },
                        ),
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

  void saveClasses() async {}

  void delete() {
    final ParentsContactsManager _contactsManager = new ParentsContactsManager();
    _contactsManager.deleteAll();
  }

  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text,
          sender: _userName,
          recipent: _currentCategory,
          dateTime: DateTime.now().toString(),
        );
        _smsManager
            .insertSMS(sms)
            .then((id) => {messageController.clear(), recipentController.clear(), print('message added to DB $id')});
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

  Future getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      setState(() {
        userName = new Text(
          _userName.toUpperCase(),
          style: TextStyle(fontFamily: 'Sans'),
        );
      });
    });
  }

  Future getContactList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      parentsCategories = prefs.getStringList('streams');
    });
  }
}
