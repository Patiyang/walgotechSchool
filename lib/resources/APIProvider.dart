import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/schoolDetails.dart';
import 'package:walgotech_final/models/users.dart';

Client client = Client();

class DBManagement {
  SmsManager _smsManager = SmsManager();
  List<SchoolDetails> schoolDetails = <SchoolDetails>[];

  String apiKey = '';
  String smsId = '';
  String url = 'http://192.168.8.129:8000/backend/operations/login.php';
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
    String url = 'http://192.168.8.129:8000/backend/operations/send.php';
    List<SchoolDetails> data = await _smsManager.getSchoolDetails();
    schoolDetails = data;
    apiKey = schoolDetails[0].smsKey;
    smsId = schoolDetails[0].smsID;
    final response = await client.post(url,
        body: jsonEncode({
          'phone': phone,
          'message': message,
          'apiKey': apiKey,
          'smsId': smsId,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('message sent');
      await showBalance();
    } else {
      throw Exception('failed to send message');
    }
  }

  showBalance() async {
    String url = 'https://payments.africastalking.com/query/wallet/balance?username=AKITHIGIRLS';
    List<SchoolDetails> data = await _smsManager.getSchoolDetails();
    schoolDetails = data;
    apiKey = schoolDetails[0].smsKey;
    final response = await client.get(
      url,
      headers: {"Authorization": apiKey},
    );
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      saveBalance(result['balance']);
    } else {
      throw Exception('failed to send message');
    }
  }

  saveBalance(String balance) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('balance', balance);
  }

  saveUName(String jwt) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userName', jwt);
  }
}
