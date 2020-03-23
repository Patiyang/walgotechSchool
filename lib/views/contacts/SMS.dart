import 'package:flutter/material.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/contacts/parentsHistory.dart';

class MessageModule extends StatefulWidget {
  @override
  _FormOneState createState() => _FormOneState();
}

class _FormOneState extends State<MessageModule> {
  final SmsManager _smsManager = new SmsManager();
  SMS sms;
  List<SMS> smsList;
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.white,
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
                    child: TextFormField(
                      maxLines: 6,
                      controller: messageController,
                      validator: (v) => v.isNotEmpty ? null : 'message is empty',
                      decoration:
                          InputDecoration(hintText: 'Type in Phone Numbers', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 6,
                      controller: recipentController,
                      validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                      decoration: InputDecoration(
                          enabled: true, hintText: 'Type in Message', border: OutlineInputBorder()),
                    ),
                  ),
                  MaterialButton(
                    color: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    minWidth: MediaQuery.of(context).size.width * .6,
                    child: Text(
                      'send',
                      style: categories,
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
                        style: categories,
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
