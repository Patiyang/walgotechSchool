import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/models/users.dart';

Client client = Client();

class DBManagement {
  String url = 'http://192.168.42.224:8000/backend/operations/login.php';
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

sendMessages(String phone, String message) async {
    String url = 'http://192.168.42.224:8000/backend/operations/send.php';

    final response = await client.post(url,
        body: jsonEncode({
          'phone': phone,
          'message': message,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('message sent');
    } else {
      throw Exception('failed to send message');
    }
  }

  saveUName(String jwt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userName', jwt);
  }
}
