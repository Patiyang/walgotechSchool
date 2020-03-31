import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:walgotech_final/database/database.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Client client = Client();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  height: 50,
                  color: Colors.white54,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.refresh,
                        size: 30,
                      ),
                      Text('Sync Data')
                    ],
                  ),
                  onPressed: () async {
                    await saveParentContacts(context);
                    await saveTeacherContacts(context);
                    await saveClasses(context);
                    await saveStreams(context);
                    await saveSubOrdinate(context);
                    Fluttertoast.showToast(msg: 'Data Has Been Updated');
                  }),
            ],
          ),
        ),
      ],
    ));
  }

  saveParentContacts(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.8.129:8000/backend/operations/readAll.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['contacts'].length; i++) {
        ParentsContacts contacts = new ParentsContacts(
          fatherNumber: result['contacts'][i]['fatherphone'].replaceFirst(RegExp('0'), '+254'),
          motherNumber: result['contacts'][i]['motherphone'].replaceFirst(RegExp('0'), '+254'),
          guardianNumber: result['contacts'][i]['guardianphone'].replaceFirst(RegExp('0'), '+254'),
          form: result['contacts'][i]['form'],
          admission: result['contacts'][i]['Admission'],
          streams: result['contacts'][i]['stream'],
        );
        smsManager.addParentsContacts(contacts).then((contact) => print('$contact has been added'));
      }
    } else {
      throw Exception('unable to add contact');
    }
  }

  saveTeacherContacts(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.8.129:8000/backend/operations/readAllTeachers.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['teachers'].length; i++) {
        TeacherContacts contacts = new TeacherContacts(
          phoneNumber: result['teachers'][i]['phone'].replaceFirst(RegExp('0'), '+254'),
          firstName: result['teachers'][i]['firstName'],
          lastName: result['teachers'][i]['lastName'],
        );
        smsManager.addTeacherContacts(contacts).then((contact) => print(' $contact has been added'));
      }
    }
  }

  saveClasses(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.8.129:8000/backend/operations/readClass.php';

    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['classes'].length; i++) {
        CurrentClasses classes = new CurrentClasses(
          registeredClasses: result['classes'][i]['className'],
        );
        print(classes.registeredClasses);
        smsManager.addClass(classes).then((_) => print('$_ class has been added'));
      }
    } else {
      throw Exception('failed to add classes');
    }
  }

  saveStreams(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.8.129:8000/backend/operations/readStream.php';

    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['streams'].length; i++) {
        CurrentStreams streams = new CurrentStreams(
          streams: result['streams'][i]['streamName'],
        );
        print(streams.streams);
        smsManager.addStream(streams).then((stream) => print('$stream has been added'));
      }
    } else {
      throw Exception('failed to add classes');
    }
  }

  saveSubOrdinate(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.8.129:8000/backend/operations/readAllSubOrdinate.php';

    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['subordinate'][i]['phone'].length; i++) {
        SubOrdinateContact subOrdinateContact = new SubOrdinateContact(
          firstName: result['subordinate'][i]['firstName'],
          lastName: result['subordinate'][i]['lastName'],
          phone: result['subordinate'][i]['phone'].replaceFirst(RegExp('0'), '+254'),
        );
        smsManager
            .addSubordinateContacts(subOrdinateContact)
            .then((subOrdinateContact) => print('$subOrdinateContact has been added'));
      }
    } else {
      throw Exception('failed to add subordinate');
    }
  }

  
}
