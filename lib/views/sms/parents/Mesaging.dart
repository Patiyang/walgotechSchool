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

enum Pages { Streams, Categories }

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  final teacherController = ScrollController();
  final parentController = ScrollController();
  final parentsController = ScrollController();
  final boardController = ScrollController();
  final supportController = ScrollController();

  final key = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  Repository _repository = Repository();

  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> parentContact;
  List<TeacherContacts> teachersContact;
  List<SubOrdinateContact> subordinateContact;
  List<CurrentClasses> classes = <CurrentClasses>[];

  String recipent = "";
  Text userName;
  String _userName;
  SMS sms;
  String groupValue = allRegistred;
  String category;
  static const allRegistred = 'All Registered';
  static const oneParent = 'One Parent';
  static const bothParents = 'Both Parents';

  static const custom = 'Custom Message';
  static const support = 'Support Staff';
  static const board = 'BoM';
  static const teachers = 'Teachers';
  static const parents = 'Parents';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollBottomContacts());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollParentContacts());
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
                              value: classes.isEmpty ? null : _currentClass,
                            ),
                          ),
                        ),
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
                            style: categoryTextStyle.copyWith(color: accentColor, fontSize: 19)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                                      recipent = "";
                                      return Container(
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
                                            print("heeeeeeey " + recipentController.text);
                                            if (groupValue == allRegistred) {
                                              recipentController.text += contacts.fatherNumber +
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
                                                return Text(contacts.motherNumber);
                                              }
                                              return Text(contacts.fatherNumber);
                                            } else if (groupValue == bothParents) {
                                              return Text(contacts.motherNumber + "," + contacts.fatherNumber);
                                            }
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
                            visible: _currentClass == parents,
                            child: Column(
                              children: <Widget>[
                                FutureBuilder(
                                  future: _smsManager.getAllParentContacts(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      parentContact = snapshot.data;
                                      return Container(
                                        decoration: BoxDecoration(border: Border.all()),
                                        height: 150,
                                        child: ListView.builder(
                                          controller: parentsController,
                                          reverse: true,
                                          addAutomaticKeepAlives: true,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: parentContact == null ? 0 : parentContact.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            ParentsContacts contacts = parentContact[index];
                                            if (groupValue == allRegistred) {
                                              print(parentContact[index].toString());

                                              return Text(contacts.fatherNumber +
                                                  "," +
                                                  contacts.motherNumber +
                                                  "," +
                                                  contacts.guardianNumber);
                                            } else if (groupValue == oneParent) {
                                              if (contacts.fatherNumber.isEmpty) {
                                                return Text(contacts.motherNumber);
                                              }
                                              return Text(contacts.fatherNumber);
                                            } else if (groupValue == bothParents) {
                                              return Text(contacts.motherNumber + "," + contacts.fatherNumber);
                                            }
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
                            visible: _currentClass == teachers,
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
                            visible: _currentClass == board,
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
                            visible: _currentClass == support,
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
                          Visibility(visible: _currentClass == custom, child: messageInput())
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
                          Text(
                            'Number Of Students: ',
                            style: categoryTextStyle.copyWith(color: accentColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Number Of SMS: ',
                            style: categoryTextStyle.copyWith(color: accentColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Sent: ',
                            style: categoryTextStyle.copyWith(color: accentColor),
                          ),
                        ],
                      ),
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
                            print(recipentController.text.toString());
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: 7,
        controller: messageController,
        validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
        decoration: InputDecoration(
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
      sendSMS(recipentController.text, messageController.text);
      // print("\n\n\n\n\n\n\n\n\n\n\n"+recipentController.text);
      if (messageController.text.toString().length > 10) {
        setState(() {
          totalMessages++;
        });
      }
    }
  }

  sendSMS(String phone, String message) async {
    await _repository.addMessage(phone, message);
  }

  // =====================================classes dd menu====================
  List<DropdownMenuItem<String>> _getClassesDropDown() {
    List<String> additonal = [custom, support, board, teachers, parents];
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
      print(_currentClass);
    });
  }

  changeSelectedCategory(String selectedClass) {
    setState(() {
      _currentClass = selectedClass;
      print(_currentClass);
    });
  }

// =================================================SAVEUSERNAMEFOR SIGN IN========================================
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
      if (value == allRegistred) {
        groupValue = value;
        category = value;
      } else if (value == oneParent) {
        groupValue = value;
        category = value;
      } else if (value == bothParents) {
        groupValue = value;
        category = value;
      }
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

  _scrollBottomContacts() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  _scrollParentContacts() {
    parentsController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}
