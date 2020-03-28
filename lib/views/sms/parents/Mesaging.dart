import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/views/sms/parents/streams.dart';
import '../../../styling.dart';

enum Pages { Streams, Categories }

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final key = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> parentContact;
  List<TeacherContacts> teachersContact;
  List<SubOrdinateContact> subordinateContact;
  List<CurrentClasses> classes = <CurrentClasses>[];

  String recipent;
  Text userName;
  String _userName;
  SMS sms;

  int totalMessages = 1;
  int totalContacts = 1;

  String _currentClass;
  @override
  void initState() {
    super.initState();
    _getClasses();
    getUserName();
    _currentClass = '';
    classesDropDown = _getClassesDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: primaryColor,
      body: Padding(
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
                              items: classesDropDown,
                              onChanged: changeSelectedCategory,
                              value: null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text('OR'),
                    SizedBox(height: 10,),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CurrentStreamClasses()));
                        },
                        child: Text('Tap to Choose Specific Streams')),
                    Divider(),
                    Visibility(
                      visible: _currentClass == 'All Parents' ||
                          _currentClass == 'Form1' ||
                          _currentClass == 'Form2' ||
                          _currentClass == 'Form3' ||
                          _currentClass == 'Form4',
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
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Visibility(
                                visible: _currentClass == 'Form1',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getFormOne(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parentContact == null ? 0 : parentContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                ParentsContacts contacts = parentContact[index];
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
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == 'Form2',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getFormTwo(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parentContact == null ? 0 : parentContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                ParentsContacts contacts = parentContact[index];
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
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == 'Form3',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getFormThree(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parentContact == null ? 0 : parentContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                ParentsContacts contacts = parentContact[index];
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
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == 'Form4',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getFormFour(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          print(parentContact.length);
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parentContact == null ? 0 : parentContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                ParentsContacts contacts = parentContact[index];
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
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == 'All Parents',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getParentContacts(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parentContact == null ? 0 : parentContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                ParentsContacts parentsContacts = parentContact[index];
                                                return Text(parentsContacts.fatherNumber +
                                                    ',' +
                                                    parentsContacts.motherNumber +
                                                    ',' +
                                                    parentsContacts.guardianNumber);
                                              },
                                            ),
                                          );
                                        }
                                        return Loading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == 'All Teachers',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getAllTeacherContacts(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          teachersContact = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: teachersContact == null ? 0 : teachersContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                print(teachersContact.length);
                                                TeacherContacts teachersContacts = teachersContact[index];
                                                return Text(teachersContacts.phoneNumber + ',');
                                              },
                                            ),
                                          );
                                        }
                                        return Loading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == 'All Subordinate',
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getSubordinateContacts(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          subordinateContact = snapshot.data;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: subordinateContact == null ? 0 : subordinateContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                SubOrdinateContact subOrdinate = subordinateContact[index];
                                                return Text(subOrdinate.phone);
                                              },
                                            ),
                                          );
                                        }
                                        return Loading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(visible: _currentClass == 'Individual Contacts', child: messageInput())
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.bottomCenter,
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
                            if (messageController.text.isNotEmpty) {
                              messageAlert();
                            } else if (messageController.text.isEmpty) {
                              key.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'Cannot send a blank text',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red[400]),
                                ),
                              ));
                            }

                            if (messageController.text.length > 10) {
                              setState(() {
                                totalMessages = 2;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget messageInput() {
    return Visibility(
      visible: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          maxLines: 7,
          controller: messageController,
          validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
          decoration: InputDecoration(
            enabled: true,
            hintText: 'Type in Mssage',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text.toString(),
          sender: _userName,
          recipent: _currentClass,
          dateTime: DateTime.now().toString(),
        );
        _smsManager.insertSMS(sms).then((id) => {
              messageController.clear(),
            });
      }
      if (messageController.text.toString().length > 10) {
        setState(() {
          totalMessages++;
        });
      }
    }
  }

  // =====================================classes dd menu====================
  List<DropdownMenuItem<String>> _getClassesDropDown() {
    List<String> additonal = ['Individual Contacts', 'All Parents', 'All Teachers', 'All Subordinate'];
    List<DropdownMenuItem<String>> dropDownItems = new List();
    for (int i = 0; i < classes.length; i++) {
      setState(() {
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(classes[i].registeredClasses),
              value: classes[i].registeredClasses,
            ));
      });
    }
    for (int f = 0; f < additonal.length; f++) {
      setState(() {
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(additonal[f]),
              value: additonal[f],
            ));
      });
    }
    return dropDownItems;
  }

  _getClasses() async {
    List<CurrentClasses> data = await _smsManager.getallClasses();

    setState(() {
      if (classes.length == 0) {
        _currentClass = '';
      }
      classes = data;
      classesDropDown = _getClassesDropDown();
      _currentClass = classes[0].registeredClasses;
      print(_currentClass);
    });
  }

  changeSelectedCategory(String selectedClass) {
    setState(() {
      _currentClass = selectedClass;
      print(_currentClass);
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

  void messageAlert() {
    var alerts = new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: .3,
      title: Column(
        children: <Widget>[
          Text('Sending: $totalMessages SMS', style: categoryTextStyle.copyWith(color: accentColor, fontSize: 17)),
          SizedBox(
            height: 20,
          ),
          Text('Sending to: ${parentContact.length} Contacts ',
              style: categoryTextStyle.copyWith(color: accentColor, fontSize: 17)),
        ],
      ),
      content: Container(
        alignment: Alignment.topLeft,
        width: 320,
        height: 90,
        child: Center(
          child: Text(
            'Are You Sure You Want To Send This Message?'.toUpperCase(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          color: Colors.red[300],
          onPressed: () {
            messageController.clear();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.cancel,
            color: accentColor,
          ),
          label: Text(
            'Cancel',
            style: categoriesStyle.copyWith(color: accentColor),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        FlatButton.icon(
          color: Colors.green[300],
          onPressed: () {
            sendMessage(context);
            Fluttertoast.showToast(msg: 'Message Sent successfuly');
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.check,
            color: accentColor,
          ),
          label: Text(
            'Done',
            style: categoriesStyle.copyWith(color: accentColor),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => alerts);
  }
}
