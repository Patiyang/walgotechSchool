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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text('Update Contacts')
                    ],
                  ),
                  onPressed: () async {
                    await saveParentContacts(context);
                    await saveTeacherContacts(context);
                    await saveSubOrdinate(context);
                    Fluttertoast.showToast(msg: 'Contacts have been updated');
                  }),
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
                      Text('Update Classes')
                    ],
                  ),
                  onPressed: () async {
                    await saveClasses(context);
                    await saveStreams(context);
                    Fluttertoast.showToast(msg: 'Classes have been updated');
                  }),
            ],
          ),
        ),
      ],
    ));
  }

  saveParentContacts(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.43.101:8000/backend/operations/readAll.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['contacts'].length; i++) {
        ParentsContacts contacts = new ParentsContacts(
          fatherNumber: result['contacts'][i]['fatherphone'],
          motherNumber: result['contacts'][i]['motherphone'],
          guardianNumber: result['contacts'][i]['guardianphone'],
          form: result['contacts'][i]['form'],
          admission: result['contacts'][i]['Admission']
        );
        
        smsManager.addParentsContacts(contacts).then((contact) => print('$contact has been added'));
      }
    } else {
      throw Exception('unable to add contact');
    }
  }

  saveTeacherContacts(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.43.101:8000/backend/operations/readAllTeachers.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['teachers'].length; i++) {
        TeacherContacts contacts = new TeacherContacts(
          phoneNumber: result['teachers'][i]['phone'],
          firstName: result['teachers'][i]['firstName'],
          lastName: result['teachers'][i]['lastName'],
        );
        print(contacts.firstName);
        smsManager.addTeacherContacts(contacts).then((contact) => print(' $contact has been added'));
      }
    }
  }

  saveClasses(BuildContext context) async {
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.43.101:8000/backend/operations/readClass.php';
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
    String url = 'http://192.168.43.101:8000/backend/operations/readStream.php';
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
    String url = 'http://192.168.43.101:8000/backend/operations/readAllSubOrdinate.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['subordinate'][i]['phone'].length; i++) {
        SubOrdinateContact subOrdinateContact = new SubOrdinateContact(
          firstName: result['subordinate'][i]['firstName'],
          lastName: result['subordinate'][i]['lastName'],
          phone: result['subordinate'][i]['phone'],
        );
        print(subOrdinateContact.phone);
        smsManager
            .addSubordinateContacts(subOrdinateContact)
            .then((subOrdinateContact) => print('$subOrdinateContact has been added'));
      }
    } else {
      throw Exception('failed to add subordinate');
    }
  }
}
