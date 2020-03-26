import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import '../../../styling.dart';

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  // final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> streamsDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> contactsList;
  List<TeacherContacts> teachersContact;
  List<SubOrdinateContact> subordinateContact;
  List<CurrentClasses> classes = <CurrentClasses>[];
  List<CurrentStreams> streams = <CurrentStreams>[];
  
  String recipent;
  Text userName;
  String _userName;
  SMS sms;
  int totalMessages = 1;
  int totalContacts = 1;

  static final individual = 'Individual Contacts';
  static final allParents = 'All Parents';
  static final teachers = 'All Teachers';
  static final subordinate = 'All Subordinate';

  List<String> additionalCategories = [individual, allParents, teachers, subordinate];
  String _currentClass = 'category';
  String _currentStream = 'stream';
  @override
  void initState() {
    super.initState();
    _getClasses();
    _getStreams();
    getUserName();
    // changeSelectedCategory(_currentClass);
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
                              items: classesDropDown,
                              onChanged: changeSelectedCategory,
                              value: _currentClass,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                              hint: Text('Select Stream'),
                              items: streamsDropDown,
                              onChanged: changeSelectedStream,
                              value: _currentStream,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Visibility(
                    //     visible: _currentCategory.isNotEmpty ,
                    //     child: MaterialButton(
                    //         elevation: 0,
                    //         color: accentColor,
                    //         child: Text(
                    //           'Send to both parents',
                    //           style: categoriesStyle,
                    //         ),
                    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    //         onPressed: () {
                    //           setState(() {});
                    //         })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: <Widget>[
                          Visibility(
                            visible: _currentClass == allParents,
                            child: FutureBuilder(
                              future: _smsManager.getParentContacts(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  contactsList = snapshot.data;
                                  return _currentClass == individual
                                      ? TextFormField(
                                          maxLines: 6,
                                          controller: messageController,
                                          validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                                          decoration: InputDecoration(
                                            enabled: true,
                                            hintText: 'Type in Message',
                                            border: OutlineInputBorder(),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
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
                                          ),
                                        );
                                }
                                return Loading();
                              },
                            ),
                          ),
                          Visibility(
                            visible: _currentClass == teachers,
                            child: FutureBuilder(
                              future: _smsManager.getAllTeacherContacts(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  teachersContact = snapshot.data;
                                  return _currentClass == individual
                                      ? TextFormField(
                                          maxLines: 6,
                                          controller: messageController,
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
                                            itemCount: teachersContact == null ? 0 : teachersContact.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              TeacherContacts teacherContact = teachersContact[index];
                                              return Text(teacherContact.phoneNumber);
                                            },
                                          ),
                                        );
                                }
                                return Loading();
                              },
                            ),
                          ),
                          Visibility(
                            visible: _currentClass == subordinate,
                            child: FutureBuilder(
                              future: _smsManager.getSubordinateContacts(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  subordinateContact = snapshot.data;
                                  return _currentClass == individual
                                      ? TextFormField(
                                          maxLines: 6,
                                          controller: messageController,
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 6,
                        controller: messageController,
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
                            Text('Sending to: Contacts', style: categoryTextStyle.copyWith(color: accentColor, fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.bottomRight,
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

  void delete() {
    final SmsManager smsManager = new SmsManager();
    // _contactsManager.deleteAll();
    smsManager.deleteAll();
  }

  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text.toString(),
          sender: _userName,
          recipent: _currentClass+" "+_currentStream,
          dateTime: DateTime.now().toString(),
        );
        _smsManager.insertSMS(sms).then((id) => {
              messageController.clear(),
            });
      }
    }
  }

// =====================================classes dd menu====================
  List<DropdownMenuItem<String>> _getClassesDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = new List();
    for (int i = 0; i < classes.length; i++) {
      setState(() {
        if (classes.length == 0 || classes == null) {
          Text('Absent');
        }
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(classes[i].registeredClasses),
              value: classes[i].registeredClasses,
            ));
      });
    }
    return dropDownItems;
  }

  _getClasses() async {
    List<CurrentClasses> data = await _smsManager.getallClasses();

    setState(() {
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

//=======================================streams dd menu============================
  List<DropdownMenuItem<String>> _getStreamsDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = new List();
    for (int i = 0; i < streams.length; i++) {
      setState(() {
        if (streams.length == 0 || streams == null) {
          Text('Absent');
        }
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(streams[i].streams),
              value: streams[i].streams,
            ));
      });
    }
    return dropDownItems;
  }

  _getStreams() async {
    List<CurrentStreams> data = await _smsManager.getallStreams();

    setState(() {
      streams = data;
      streamsDropDown = _getStreamsDropDown();
      _currentStream = streams[0].streams;
      print(_currentStream);
    });
  }

  changeSelectedStream(String selectedStream) {
    setState(() {
      _currentStream = selectedStream;
      print(_currentStream);
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
}
