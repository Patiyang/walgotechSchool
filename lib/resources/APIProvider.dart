import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/classes.dart';
import 'package:walgotech_final/models/contacts.dart';
import 'package:walgotech_final/models/users.dart';

Client client = Client();

class DBManagement {
  // String url = 'http://192.168.100.10:8000/backend/operations/login.php';
    String url = 'http://192.168.122.1:8000/backend/operations/login.php';

  Future<User> signInUser(String userName, String password) async {
    final response = await client.post(url,
        body: jsonEncode({
          'userName': userName,
          'password': password,
        }));
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await saveUName(result['userName']);
    } else {
      throw Exception('cannot add the user to pref list');
    }
    return User.fromJson(json.decode(response.body));
  }

  saveUName(String jwt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userName', jwt);
  }
}

class Synchronization {
  saveParentContacts(BuildContext context) async {
    final ParentsContactsManager parentsContactManager = new ParentsContactsManager();
    // String url = 'http://192.168.100.10:8000/backend/operations/readAll.php';
    String url = 'http://192.168.122.1:8000/backend/operations/readAll.php';
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
    final ClassesManager classesManager = new ClassesManager();
    String url = 'http://192.168.100.10:8000/backend/operations/readClass.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['classes'].length; i++) {
        CurrentClasses classes = new CurrentClasses(
          registeredClasses: result['classes'][i]['className'],
        );
        print(classes.registeredClasses);
        classesManager
            .addClass(classes)
            .then((_) => print('$_ class has been added'))
            .then((f) => Fluttertoast.showToast(msg: 'classes updated successfully'));
      }
    } else {
      throw Exception('failed to add classes');
    }
  }

  saveStreams(BuildContext context) async {
    final StreamsManager streamsManager = new StreamsManager();
    String url = 'http://192.168.100.10:8000/backend/operations/readStream.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['streams'].length; i++) {
        CurrentStreams streams = new CurrentStreams(
          streamName: result['streams'][i]['streamName'],
        );
        print(streams.streamName);
        streamsManager.addStream(streams).then((stream) => print('$stream has been added'));
      }
    } else {
      throw Exception('failed to add classes');
    }
  }
}
