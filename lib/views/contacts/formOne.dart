import 'package:flutter/material.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/styling.dart';

class FormOne extends StatefulWidget {
  @override
  _FormOneState createState() => _FormOneState();
}

class _FormOneState extends State<FormOne> {
  final SmsManager _smsManager = new SmsManager();
  SMS sms;
  List<SMS> smsList;
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Form 1 Contacts'),
      ),
      body: Material(color: Colors.white,
              child: ListView(
          physics: BouncingScrollPhysics(),
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
                    child: Text('send',style: categories,),
                    onPressed: () {
                      sendMessage(context);
                    },
                  ),
                  FutureBuilder(
                    future: _smsManager.getSMSList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        smsList = snapshot.data;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: smsList == null ? 0 : smsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            SMS message = smsList[index];
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                color: primaryColor,
                                child: ListTile(
                                  title: Text('${message.message}'),
                                  leading: Text('${message.sender}:'),
                                  subtitle: Text('${message.dateTime}'),
                                  trailing: Container(
                                    width: 115,
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              _smsManager.deleteAll();
                                              setState(() {
                                                // smsList.removeAt(index);
                                              });
                                            }),
                                        SizedBox(width: 10),
                                        IconButton(icon: Icon(Icons.edit), onPressed: () {})
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
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
