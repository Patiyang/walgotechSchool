import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/resources/repository.dart';

import '../../../styling.dart';

class CurrentStreamClasses extends StatefulWidget {
  @override
  _CurrentStreamClassesState createState() => _CurrentStreamClassesState();
}

class _CurrentStreamClassesState extends State<CurrentStreamClasses> {
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  ScrollController _scrollController = ScrollController();

  final formKey = new GlobalKey<FormState>();
  final scafoldKey = new GlobalKey<ScaffoldState>();
  Repository _repository = Repository();

  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> streamsDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> parentContact;
  List<CurrentStreams> streams = <CurrentStreams>[];
  String _currentStream;
  String recipent;
  Text userName;
  String _userName;
  SMS sms;

  int totalMessages = 0;
  int totalStudents;
  List totalContacts = [];
  int totalTeachers;
  int totalSupport;
  int totalBoard;
  int totalParents;

  String groupValue = '';
  String category;
  static const allRegistred = 'All Registered';
  static const oneParent = 'One Parent';
  static const bothParents = 'Both Parents';
  static const custom = 'Custom Message';

  @override
  void initState() {
    super.initState();
    _getStreams();
    getUserName();
    totalStudents = 0;
    messageController.addListener(_messageLength);
    _currentStream = 'stream';
    streamsDropDown = _getStreamsDropDown();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollBottomContacts());

    return Scaffold(
      key: scafoldKey,
      appBar: GradientAppBar(
        gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
        elevation: .3,
        centerTitle: true,
        title: Text('Student Streams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Material(
                      elevation: 0,
                      color: Colors.cyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Visibility(
                          visible: true,
                          child: DropdownButton(
                            underline: SizedBox(),
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.black26,
                            ),
                            hint: Text('Select Stream'),
                            items: streamsDropDown,
                            onChanged: changeSelectedStream,
                            value: streams.isEmpty ? null : _currentStream,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
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
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Visibility(
                      visible: _currentStream == _currentStream,
                      child: streams.isEmpty
                          ? Loading()
                          : FutureBuilder(
                              future: _smsManager.getStreamsContacts(_currentStream.split(' ')[0], _currentStream.split(' ')[1]),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  parentContact = snapshot.data;
                                  totalStudents = parentContact.length;
                                  return groupValue == ''
                                      ? Text('Please Pick a Contact Group Above First')
                                      : Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
                                          height: 150,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            reverse: true,
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: parentContact == null ? 0 : parentContact.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              ParentsContacts contacts = parentContact[index];
                                              // totalStudents = parentContact.length;
                                              if (_currentStream == _currentStream) {
                                                print(recipentController.text);
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
                                                    recipentController.text += contacts.motherNumber + ",";
                                                    return Text(contacts.motherNumber);
                                                  }
                                                  recipentController.text += contacts.fatherNumber + ",";
                                                  return Text(contacts.fatherNumber);
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

                                return Loading();
                              },
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: messageInput(),
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
                          'Number Of Students: $totalStudents',
                          style: categoryTextStyle.copyWith(color: accentColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Number Of SMS: $totalMessages',
                          style: categoryTextStyle.copyWith(color: accentColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sent:$totalMessages /${totalContacts.length}',
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
                        color: Colors.cyan,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        minWidth: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          'Send',
                          style: categoriesStyle.copyWith(color: accentColor),
                        ),
                        onPressed: () {
                          if (groupValue == '') {
                            Fluttertoast.showToast(msg: 'No Contact Category Selected');
                          } else if (messageController.text.isNotEmpty) {
                            messageAlert();
                          } else if (messageController.text.isEmpty && formKey.currentState.validate()) {
                            scafoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                              'Cannot send a blank text',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red[400]),
                            )));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          validator: (v) {
            if (v.isEmpty) return 'cannot send a blank text';
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            enabled: true,
            hintText: 'Type in Message',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

//=======================================streams dd menu============================
  List<DropdownMenuItem<String>> _getStreamsDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = new List();

    for (int i = 0; i < streams.length; i++) {
      setState(() {
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
      if (streams.isEmpty) _currentStream = '';
      streams = data;
      streamsDropDown = _getStreamsDropDown();

      _currentStream = streams[0].streams;
    });
    totalStudents = parentContact.length;
  }

  changeSelectedStream(String selectedStream) async {
    setState(() {
      _currentStream = selectedStream;
      // totalStudents = parentContact.length;
      groupValue = '';
      totalStudents = 0;
      totalContacts.length = 0;
    });
  }

// =======================================================================================
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

// ============================================================SEND SAVE=======================
  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text.toString(),
          sender: _userName,
          recipent: _currentStream,
          dateTime: DateTime.now().toString(),
        );
        _smsManager.insertSMS(sms).then((id) => {
              messageController.clear(),
            });
      }
    }
  }

// ======================================RADIO===========================
  categoryChanged(String value) {
    setState(() {
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
            if (contacts.motherNumber.isNotEmpty) totalContacts.add(contacts.motherNumber);
          } else if (contacts.fatherNumber.isNotEmpty) {
            totalContacts.add(contacts.fatherNumber);
          }
        } else if (value == bothParents) {
          groupValue = value;
          category = value;
          if (contacts.fatherNumber.isNotEmpty && contacts.motherNumber.isNotEmpty) {
            totalContacts.add(contacts.motherNumber);
            totalContacts.add(contacts.fatherNumber);
          }
        }
      }
    });
  }

// =========================================DIALOG===================================
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
            await sendSMS(recipentController.text, messageController.text);
            sendMessage(context);
            Fluttertoast.showToast(msg: 'Message Sent to $groupValue in $_currentStream');
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

  sendSMS(String phone, String message) async {
    await _repository.addMessage(phone, message);
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
