import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/models/users.dart';

class DBManagement {
  Client client = Client();
  String url = 'http://192.168.100.10:8000/backend/operations/login.php';
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