import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/sms.dart';


class ParentHistory extends StatefulWidget {
  @override
  _ParentHistoryState createState() => _ParentHistoryState();
}

class _ParentHistoryState extends State<ParentHistory> {
  final SmsManager _smsManager = new SmsManager();
  Text userName;
  String _userName;
  SMS sms;
  @override
  void initState() { 
    super.initState();
    getUserName();
  }
  List<SMS> smsList;
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: .2,
        centerTitle: true,
        title: Text('Parents Messages History'),
      ),
      body: FutureBuilder(
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
                  padding: const EdgeInsets.all(6.0),
                  child: Material(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.black38,
                    child: ListTile(
                      title: Text('${message.message}'),
                      leading: userName,
                      subtitle: Text('Sent on: ${message.dateTime}'),
                      trailing: Container(
                        height: 115,
                        child: Column(
                          children: <Widget>[
                            // IconButton(
                            //     icon: Icon(
                            //       Icons.delete,
                            //       color: Colors.black,
                            //     ),
                            //     onPressed: () {
                            //       _smsManager.deleteAll();
                            //       setState(() {
                            //         // smsList.removeAt(index);
                            //       });
                            //     }),
                            // SizedBox(width: 10),
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
    );
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
