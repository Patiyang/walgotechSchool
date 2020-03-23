import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/models/users.dart';

class DBManagement {
  Client client = Client();
String url = 'http://10.0.2.2:8000/backend/operations/login.php';
  Future<User> signInUser(String userName, String password) async {
    final response = await client.post(url,
        body: jsonEncode({
          'userName': userName,
          'password': password,
        }));
    final Map result = json.decode(response.body);
    if (response.statusCode == 200) {
      saveContacts(result['contacts']);
      saveUName(result['userName']);
    } else {
      throw Exception('cannot add the user to pref list');
    }
    return User.fromJson(json.decode(response.body));
  }

  Future saveContacts(List<String> contacts) async {
    List<String> contacts = [];

    String url = 'http://10.0.2.2:8000/backend/operations/read_contacts.php';
    final response = await client.get(url);
    final Map result = json.decode(response.body);

    if (response.statusCode == 200) {
      for (int i = 0; i < result['contacts'].length; i++) {
        contacts.add(result['contacts'][i]['contact']);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('contacts', contacts);
      return contacts;
    } else {
      throw Exception('cannot add the user to pref list');
    }
  }

  saveUName(String jwt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userName', jwt);
  }
}
