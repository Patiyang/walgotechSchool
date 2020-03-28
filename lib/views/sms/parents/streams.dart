import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
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
  final key = new GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> classesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> streamsDropDown = <DropdownMenuItem<String>>[];
  List<ParentsContacts> parentContact;
  List<CurrentStreams> streams = <CurrentStreams>[];

  String recipent;
  Text userName;
  String _userName;
  SMS sms;

  int totalMessages = 1;
  int totalContacts = 1;

  String _currentStream;
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
                          value: null,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
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
                for(int i=0;i<streams.length;i++)
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Visibility(
                    visible: _currentStream == streams[i].streams,
                    child: FutureBuilder(
                      future: _smsManager.getStreamsContacts(),
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
                                return Text(contacts.motherNumber + "," + contacts.motherNumber + "," + contacts.guardianNumber);
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
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('data')));
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
      _currentStream = streams.isEmpty ? _currentStream = '' : streams[0].streams;
       print(streams[0].streams);
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
}
