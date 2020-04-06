import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/resources/repository.dart';
import 'package:walgotech_final/views/sms/parents/streams.dart';
import '../../../styling.dart';
import '../search.dart';

enum Pages { Streams, Categories }

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final singleClassController = new TextEditingController();
  final individualController = new TextEditingController();
  final boardtextController = new TextEditingController();
  final teacherstextController = new TextEditingController();
  final supporttextController = new TextEditingController();

  ScrollController _scrollController = ScrollController();

  final key = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  Repository _repository = Repository();

  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> parentContact;
  List<TeacherContacts> teachersContact;
  List<SubOrdinateContact> supportContact;
  List<CurrentClasses> classes = <CurrentClasses>[];

  bool loading = false;
  String recipent = "";
  Text userName;
  String _userName;
  SMS sms;
  String groupValue;
  String category;
  static const allRegistred = 'All Registered';
  static const oneParent = 'One Parent';
  static const bothParents = 'Both Parents';

  static const custom = 'Custom Contacts';
  static const support = 'Support Staff';
  static const board = 'BoM';
  static const teachers = 'Teachers';
  static const parents = 'All Parents';

  int totalMessages;
  List totalContacts = [];
  int totalStudents;
  int totalTeachers;
  int totalSupport;
  int totalBoard;
  int totalParents;
  String _currentClass;

  @override
  void initState() {
    super.initState();

    _smsManager.getParentContacts(_currentClass);
    totalContacts.clear();
    _getClasses();
    getUserName();
    groupValue = '';
    totalMessages = 0;
    totalContacts = [];
    totalStudents = 0;
    totalTeachers = 0;
    totalSupport = 0;
    totalBoard = 0;
    totalParents = 0;
    messageController.addListener(_messageLength);
    classesDropDown = _getClassesDropDown();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollBottomContacts());
    return Scaffold(
      key: key,
      backgroundColor: primaryColor,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: 300,
                                  child: Material(
                                    elevation: 0,
                                    color: Colors.cyan,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: DropdownButton(
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.black,
                                        ),
                                        hint: Text('Select Category'),
                                        items: classesDropDown,
                                        onChanged: changeSelectedCategory,
                                        disabledHint: Text('Select Category'),
                                        value: classes.isEmpty ? null : _currentClass,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (_) => StudentSearch()));
                                    showSearch(context: context, delegate: DataSearch());
                                  })
                            ],
                          ),
                        ),
                        Visibility(
                            visible: _currentClass != custom &&
                                _currentClass != board &&
                                _currentClass != teachers &&
                                _currentClass != support,
                            child: Text('OR')),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _currentClass != custom &&
                              _currentClass != board &&
                              _currentClass != teachers &&
                              _currentClass != support,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => CurrentStreamClasses()));
                            },
                            child: Text('Tap to Choose Specific Streams',
                                style: categoryTextStyle.copyWith(
                                    color: Colors.green, fontSize: 19, decoration: TextDecoration.underline)),
                          ),
                        ),
                        Visibility(
                          visible: _currentClass != board &&
                              _currentClass != custom &&
                              _currentClass != support &&
                              _currentClass != teachers,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(allRegistred),
                                        Radio(
                                          autofocus: true,
                                          value: allRegistred,
                                          groupValue: groupValue,
                                          onChanged: (value) => categoryChanged(value),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(oneParent),
                                        Radio(
                                          value: oneParent,
                                          groupValue: groupValue,
                                          onChanged: (value) => categoryChanged(value),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(bothParents),
                                        Radio(
                                          value: bothParents,
                                          groupValue: groupValue,
                                          onChanged: (value) => categoryChanged(value),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Visibility(
                                visible: _currentClass == _currentClass &&
                                    _currentClass != parents &&
                                    _currentClass != support &&
                                    _currentClass != board &&
                                    _currentClass != custom &&
                                    _currentClass != teachers,
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getParentContacts(_currentClass),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          totalStudents = parentContact.length;
                                          return groupValue == ''
                                              ? Text('Please Pick a Contact Group Above First')
                                              : Container(
                                                  decoration: BoxDecoration(border: Border.all()),
                                                  height: 150,
                                                  child: ListView.builder(
                                                    reverse: true,
                                                    controller: _scrollController,
                                                    physics: BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: parentContact == null ? 0 : parentContact.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      ParentsContacts contacts = parentContact[index];
                                                      // print("total Students are ${parentContact.length}");
                                                      if (_currentClass == 'Form1' ||
                                                          _currentClass == 'Form2' ||
                                                          _currentClass == 'Form3' ||
                                                          _currentClass == 'Form4') if (groupValue == allRegistred) {
                                                        singleClassController.text += contacts.fatherNumber +
                                                            "," +
                                                            contacts.motherNumber +
                                                            "," +
                                                            contacts.guardianNumber;
                                                        // print("hello ${singleClassController.text}");
                                                        return Text(contacts.fatherNumber +
                                                            "," +
                                                            contacts.motherNumber +
                                                            "," +
                                                            contacts.guardianNumber);
                                                      } else if (groupValue == oneParent) {
                                                        if (contacts.fatherNumber.isEmpty) {
                                                          singleClassController.text += contacts.motherNumber + ",";
                                                          // print("hello ${singleClassController.text}");
                                                          return Text(contacts.motherNumber + ",");
                                                        } else {
                                                          singleClassController.text += contacts.fatherNumber + ",";
                                                          // print("hello ${singleClassController.text}");
                                                          return Text(contacts.fatherNumber + ",");
                                                        }
                                                      } else if (groupValue == bothParents) {
                                                        singleClassController.text +=
                                                            contacts.fatherNumber + "," + contacts.motherNumber + ",";
                                                        // print("hello mom and dad ${singleClassController.text}");
                                                        return Text(contacts.motherNumber + "," + contacts.fatherNumber);
                                                      }
                                                    },
                                                  ),
                                                );
                                        }
                                        return PlainLoading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == parents,
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getAllParentContacts(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          parentContact = snapshot.data;
                                          totalStudents = parentContact.length;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              reverse: true,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parentContact == null ? 0 : parentContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                ParentsContacts contacts = parentContact[index];
                                                if (_currentClass == parents) {
                                                  if (groupValue == allRegistred) {
                                                    recipentController.text = contacts.fatherNumber +
                                                        "," +
                                                        contacts.motherNumber +
                                                        "," +
                                                        contacts.guardianNumber;
                                                    return Text(contacts.fatherNumber +
                                                        "," +
                                                        contacts.motherNumber +
                                                        "," +
                                                        contacts.guardianNumber);
                                                  } else if (groupValue == oneParent) {
                                                    if (contacts.fatherNumber.isEmpty) {
                                                      recipentController.text += contacts.motherNumber + ",";
                                                      // print("hello ${recipentController.text}");
                                                      return Text(contacts.motherNumber + ",");
                                                    } else {
                                                      recipentController.text += contacts.fatherNumber + ",";
                                                      // print("hello ${recipentController.text}");
                                                      return Text(contacts.fatherNumber + ",");
                                                    }
                                                  } else if (groupValue == bothParents) {
                                                    recipentController.text +=
                                                        contacts.fatherNumber + "," + contacts.motherNumber + ",";
                                                    return Text(contacts.motherNumber + "," + contacts.fatherNumber);
                                                  }
                                                }
                                              },
                                            ),
                                          );
                                        }
                                        return PlainLoading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _currentClass == teachers,
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getAllTeacherContacts(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          teachersContact = snapshot.data;
                                          totalTeachers = teachersContact.length;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              scrollDirection: Axis.vertical,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              reverse: true,
                                              itemCount: teachersContact == null ? 0 : teachersContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                TeacherContacts teachersContacts = teachersContact[index];
                                                if (_currentClass == teachers) {
                                                  teacherstextController.text += teachersContacts.phoneNumber + ',';
                                                  // print(teacherstextController.text);
                                                }
                                                return Text(teachersContacts.phoneNumber + ',');
                                              },
                                            ),
                                          );
                                        }
                                        return PlainLoading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              // Visibility(
                              //   visible: _currentClass == board,
                              //   child: Column(
                              //     children: <Widget>[
                              //       FutureBuilder(
                              //         future: _smsManager.getAllTeacherContacts(),
                              //         builder: (BuildContext context, AsyncSnapshot snapshot) {
                              //           if (snapshot.hasData) {
                              //             teachersContact = snapshot.data;
                              //             totalTeachers = teachersContact.length;

                              //             return Container(
                              //               decoration: BoxDecoration(border: Border.all()),
                              //               height: 150,
                              //               child: ListView.builder(
                              //                 controller: _scrollController,
                              //                 scrollDirection: Axis.vertical,
                              //                 physics: BouncingScrollPhysics(),
                              //                 shrinkWrap: true,
                              //                 reverse: true,
                              //                 itemCount: teachersContact == null ? 0 : teachersContact.length,
                              //                 itemBuilder: (BuildContext context, int index) {
                              //                   print(teachersContact.length);
                              //                   TeacherContacts teachersContacts = teachersContact[index];
                              //                   if (groupValue == board) {
                              //                     boardtextController.text = teachersContacts.phoneNumber + ',';
                              //                   }
                              //                   return Text(teachersContacts.phoneNumber + ',');
                              //                 },
                              //               ),
                              //             );
                              //           }
                              //           return Loading();
                              //         },
                              //       ),
                              //       messageInput()
                              //     ],
                              //   ),
                              // ),
                              Visibility(
                                visible: _currentClass == support,
                                child: Column(
                                  children: <Widget>[
                                    FutureBuilder(
                                      future: _smsManager.getSubordinateContacts(),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          supportContact = snapshot.data;
                                          totalSupport = supportContact.length;
                                          return Container(
                                            decoration: BoxDecoration(border: Border.all()),
                                            height: 150,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              reverse: true,
                                              itemCount: supportContact == null ? 0 : supportContact.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                // print(supportContact.length);
                                                SubOrdinateContact subOrdinate = supportContact[index];
                                                if (_currentClass == support) {
                                                  supporttextController.text += subOrdinate.phone + ',';
                                                }
                                                return Text(subOrdinate.phone + ',');
                                              },
                                            ),
                                          );
                                        }
                                        return PlainLoading();
                                      },
                                    ),
                                    messageInput()
                                  ],
                                ),
                              ),
                              Visibility(
                                  visible: _currentClass == custom,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: individualController,
                                        maxLines: 7,
                                        validator: (v) {
                                          if (v.length < 13) return 'The Number is too short';
                                          if (v.isEmpty)
                                            return 'cannot send a blank text';
                                          else
                                            return null;
                                        },
                                        decoration: InputDecoration(
                                          enabled: true,
                                          hintText: 'Message Separated by Commas e.g +254xxxxx,+254xxxxx',
                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      messageInput(),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: _currentClass != teachers &&
                                        _currentClass != board &&
                                        _currentClass != custom &&
                                        _currentClass != support,
                                    child: Table(
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Number Of Students: ',
                                                style: categoryTextStyle.copyWith(color: accentColor),
                                              ),
                                            ),
                                          ]),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Text('$totalStudents'),
                                              ],
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Number Of SMS: ',
                                                style: categoryTextStyle.copyWith(color: accentColor),
                                              ),
                                            ),
                                          ]),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text('$totalMessages'),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Text(
                                                  'Sending:',
                                                  style: categoryTextStyle.copyWith(color: accentColor),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text('$totalMessages /${totalContacts.length * totalMessages}'),
                                              )
                                            ],
                                          )
                                        ])
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _currentClass == teachers,
                                    child: Table(
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Number Of SMS: ',
                                                style: categoryTextStyle.copyWith(color: accentColor),
                                              ),
                                            ),
                                          ]),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text('$totalMessages'),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Text(
                                                  'Sending:',
                                                  style: categoryTextStyle.copyWith(color: accentColor),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text('$totalMessages /${totalTeachers * totalMessages}'),
                                              )
                                            ],
                                          )
                                        ])
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _currentClass == support,
                                    child: Table(
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Number Of SMS: ',
                                                style: categoryTextStyle.copyWith(color: accentColor),
                                              ),
                                            ),
                                          ]),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text('$totalMessages'),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        TableRow(children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Text(
                                                  'Sending:',
                                                  style: categoryTextStyle.copyWith(color: accentColor),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text('$totalMessages /${totalSupport * totalMessages}'),
                                              )
                                            ],
                                          )
                                        ])
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: MaterialButton(
                              color: Colors.cyan,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              minWidth: MediaQuery.of(context).size.width * .3,
                              child: Text(
                                'Send',
                                style: categoriesStyle.copyWith(color: accentColor),
                              ),
                              onPressed: () {
                                if (messageController.text.isNotEmpty && formKey.currentState.validate()) {
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
          Visibility(visible: loading ?? true, child: Loading())
        ],
      ),
    );
  }

  Widget messageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: 7,
        onTap: () {
          if (_currentClass == teachers) {
            totalTeachers = teachersContact.length;
          }
          if (_currentClass == support) {
            totalSupport = supportContact.length;
          }
        },
        controller: messageController,
        validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          enabled: true,
          hintText: 'Type in Message',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

// ===============================SEMDmessage==========================
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
    }
  }

  // =====================================classes dd menu====================
  List<DropdownMenuItem<String>> _getClassesDropDown() {
    List<String> additonal = [custom, support, teachers, parents];
    List<DropdownMenuItem<String>> dropDownItems = new List();
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
    });
  }

  changeSelectedCategory(String selectedClass) {
    setState(() {
      teacherstextController.clear();
      supporttextController.clear();
      singleClassController.clear();
      recipentController.clear();
      _currentClass = selectedClass;
      groupValue = '';
      totalStudents = 0;
      totalTeachers = 0;
      totalSupport = 0;
      totalBoard = 0;
    });

    print(_currentClass);
    totalContacts.clear();
  }

// =================================================SAVEUSERNAME FOR SIGN IN========================================
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

// ==========================================================CATEGORYCHANGED==========================================
  categoryChanged(String value) {
    setState(() {
      singleClassController.clear();
      recipentController.clear();
      totalContacts.clear();
      for (int i = 0; i < parentContact.length; i++) {
        var contacts = parentContact[i];
        if (value == allRegistred) {
          groupValue = value;
          category = value;
          if (contacts.fatherNumber.isNotEmpty) {
            totalContacts.add(contacts.fatherNumber);
          }
          if (contacts.motherNumber.isNotEmpty) {
            totalContacts.add(contacts.motherNumber);
          }
          if (contacts.guardianNumber.isNotEmpty) {
            totalContacts.add(contacts.guardianNumber);
          }
        } else if (value == oneParent) {
          groupValue = value;
          category = value;
          if (contacts.fatherNumber.isEmpty) {
            totalContacts.add(contacts.motherNumber);
          } else {
            totalContacts.add(contacts.fatherNumber);
          }
        } else if (value == bothParents) {
          groupValue = value;
          category = value;
          if (contacts.fatherNumber.isNotEmpty) {
            totalContacts.add(contacts.fatherNumber);
          }
          if (contacts.motherNumber.isNotEmpty) {
            totalContacts.add(contacts.motherNumber);
          }
        }
      }
    });
  }

  void messageAlert() {
    var alerts = new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: .3,
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
          onPressed: () async {
            Fluttertoast.showToast(msg: 'sending...');
            if (_currentClass == custom) {
              setState(() {
                loading = true;
              });
              Navigator.pop(context);
              await postSMS(_userName, messageController.text, _currentClass, DateTime.now().toString());
              await sendSMS(individualController.text, messageController.text);
              setState(() {
                loading = false;
              });
              Fluttertoast.showToast(msg: 'Custom Message Sent');
            }

            // if (_currentClass == board) {
            //   sendSMS(boardtextController.text, messageController.text);
            //   Fluttertoast.showToast(msg: 'Board Message Sent');
            // }
            if (_currentClass == support) {
              setState(() {
                loading = true;
              });
              Navigator.pop(context);
              await postSMS(_userName, messageController.text, _currentClass, DateTime.now().toString());
              await sendSMS(supporttextController.text, messageController.text);
              setState(() {
                loading = false;
              });
              Fluttertoast.showToast(msg: 'Support staff Message Sent');
            }
            if (_currentClass == teachers) {
              setState(() {
                loading = true;
              });
              Navigator.pop(context);
              await postSMS(_userName, messageController.text, _currentClass, DateTime.now().toString());
              await sendSMS(teacherstextController.text, messageController.text);
              setState(() {
                loading = false;
              });
              Fluttertoast.showToast(msg: 'Teacher Message Sent ');
              setState(() {
                loading = false;
              });
            }
            if (_currentClass == parents) {
              setState(() {
                loading = true;
              });
              Navigator.pop(context);
              await postSMS(_userName, messageController.text, _currentClass, DateTime.now().toString());
              await sendSMS(recipentController.text, messageController.text);
              Fluttertoast.showToast(msg: 'Sent to $groupValue');
              setState(() {
                loading = false;
              });
            }
            if (_currentClass == 'Form1' || _currentClass == 'Form2' || _currentClass == 'Form3' || _currentClass == 'Form4') {
              setState(() {
                loading = true;
              });
              Navigator.pop(context);
              await postSMS(_userName, messageController.text, _currentClass, DateTime.now().toString());
              await sendSMS(singleClassController.text, messageController.text);
              if (_currentClass == 'Form1') {
                Fluttertoast.showToast(msg: 'Sent to $groupValue in Form1');
                setState(() {
                  loading = false;
                });
              }
              if (_currentClass == 'Form2') {
                Fluttertoast.showToast(msg: 'Sent to $groupValue in Form2');
                setState(() {
                  loading = false;
                });
              }
              if (_currentClass == 'Form3') {
                Fluttertoast.showToast(msg: 'Sent to $groupValue in Form3');
                setState(() {
                  loading = false;
                });
              }
              if (_currentClass == 'Form4') {
                Fluttertoast.showToast(msg: 'Sent to $groupValue in Form4');
                setState(() {
                  loading = false;
                });
              }
            }

            sendMessage(context);
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

  sendSMS(String phone, String message) async {
    await _repository.addMessage(phone, message);
  }

  postSMS(String userName, String message, String recipent, String time) async {
    await _repository.uploadMessages(userName, message, recipent, time);
  }

  _messageLength() {
    // print('the message length is ${messageController.text.length}');
    setState(() {
      if (messageController.text.length < 1) {
        totalMessages = 0;
      } else if (messageController.text.length > 0 && messageController.text.length < 160) {
        totalMessages = 1;
      } else if (messageController.text.length > 160 && messageController.text.length < 320) {
        totalMessages = 2;
      } else if (messageController.text.length > 320 && messageController.text.length < 640) {
        totalMessages = 3;
      } else if (messageController.text.length > 640 && messageController.text.length < 1280) {
        totalMessages = 4;
      } else if (messageController.text.length > 1280 && messageController.text.length < 2560) {
        totalMessages = 5;
      }
    });
  }

  _scrollBottomContacts() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
