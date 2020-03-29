import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/error.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/sms.dart';

import '../../../styling.dart';

class CurrentStreamClasses extends StatefulWidget {
  @override
  _CurrentStreamClassesState createState() => _CurrentStreamClassesState();
}

class _CurrentStreamClassesState extends State<CurrentStreamClasses> {
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final scafoldKey = new GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> streamsDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> parentContact;
  List<CurrentStreams> streams = <CurrentStreams>[];
  String _currentStream;
  String recipent;
  Text userName;
  String _userName;
  SMS sms;

  int totalMessages = 1;
  int totalContacts = 1;

  String groupValue = allRegistred;
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

    _currentStream = 'stream';
    streamsDropDown = _getStreamsDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
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
                      color: Colors.black26,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Visibility(
                          visible: true,
                          child: DropdownButton(
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
                                  return Container(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
                                    height: 150,
                                    child: ListView.builder(
                                      // addAutomaticKeepAlives:true ,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: parentContact == null ? 0 : parentContact.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        ParentsContacts contacts = parentContact[index];
                                        if (groupValue == allRegistred) {
                                          print(contacts.toString());
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
                            scafoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                              'Cannot send a blank text',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red[400]),
                            )));
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
  }

  changeSelectedStream(String selectedStream) {
    setState(() {
      _currentStream = selectedStream;
      print(_currentStream);
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

// =========================================DIALOG===================================
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
      if (messageController.text.toString().length > 10) {
        setState(() {
          totalMessages++;
        });
      }
    }
  }

// ======================================RADIO===========================
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
}
