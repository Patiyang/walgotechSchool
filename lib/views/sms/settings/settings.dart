import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  }),
            ],
          ),
        ),
      ],
    ));
  }

  saveParentContacts(BuildContext context) async {
    final ParentsContactsManager parentsContactManager = new ParentsContactsManager();
    String url = 'http://192.168.100.10:8000/backend/operations/readAll.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['contacts'].length; i++) {
        ParentsContacts contacts = new ParentsContacts(
          fatherNumber: result['contacts'][i]['fatherphone'],
          motherNumber: result['contacts'][i]['motherphone'],
          guardianNumber: result['contacts'][i]['guardianphone'],
          form: result['contacts'][i]['form'],
        );
        parentsContactManager.addParentsContacts(contacts).then((contact) => print('$contact has been added'));
        // parentsContactManager.query();
      }
    } else {
      throw Exception('unable to add contact');
    }
  }

  saveTeacherContacts(BuildContext context) async {
    final TeacherManager _contactsManager = new TeacherManager();
    String url = 'http://192.168.100.10:8000/backend/operations/readAllTeachers.php';
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
        _contactsManager
            .addContacts(contacts)
            .then((contact) => print(' $contact has been added'))
            .then((_) => Fluttertoast.showToast(msg: 'Contacts Updated Successfully'));
      }
    }
  }

  saveClasses(BuildContext context) async {
    List<String> classes = [];
    String url = 'http://192.168.100.10:8000/backend/operations/readClass.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['classes'].length; i++) {
        classes.add(result['classes'][i]['className']);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('classList', classes);
      classes = prefs.getStringList('classList');
      print(classes);
      return context;
    } else {
      throw Exception('failed to add classes');
    }
  }

  saveStreams(BuildContext context) async {
    List<String> streams = [];
    String url = 'http://192.168.100.10:8000/backend/operations/readStream.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['streams'].length; i++) {
        streams.add(result['streams'][i]['StreamName']);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('streams', streams);
      streams = prefs.getStringList('streams');
      print(streams);
      return context;
    } else {
      throw Exception('failed to add classes');
    }
  }
}
