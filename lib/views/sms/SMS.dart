import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/styling.dart';

import 'parents/parentsHistory.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final SmsManager _smsManager = new SmsManager();
  String _userName;
  Text userName;
  SMS sms;
 
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
              child: Column(
          // physics: BouncingScrollPhysics(),
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(readOnly: true,
                      maxLines: 4,
                      controller: messageController,
                      validator: (v) => v.isNotEmpty ? null : 'message is empty',
                      decoration:
                          InputDecoration(hintText: 'Pick a Category above', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 6,
                      controller: recipentController,
                      validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                      decoration: InputDecoration(
                          enabled: true, hintText: 'Type in Message', border: OutlineInputBorder(),),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      minWidth: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        'View History',
                        style: categoriesStyle,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ParentHistory()));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text,
          sender: recipentController.text,
          dateTime: DateTime.now().toString(),
        );
        _smsManager.insertSMS(sms).then((id) =>
            {messageController.clear(), recipentController.clear(), print('Student added to DB $id')});
      }
    }
  }
}
