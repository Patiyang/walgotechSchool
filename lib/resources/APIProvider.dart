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

  sendMessages(String phone, String message) async {
    String url = 'http://192.168.122.1:8000/backend/operations/send.php';
    // List<SchoolDetails> data = await _smsManager.getSchoolDetails();
    // schoolDetails = data;
    // apiKey = schoolDetails[0].smsKey;
    // smsId = schoolDetails[0].smsID;
    final response = await client.post(url,
        body: jsonEncode({
          'phone': phone,
          'message': message,
          // 'apiKey': apiKey,
          // 'smsId': smsId,
        }));
    print('${response.statusCode}');
    print(smsId);
    print(apiKey);
    if (response.statusCode == 200) {
      print('message sent');
      showBalance();
    } else {
      throw Exception('failed to send message');
    }
  }

  showBalance() async {
    List<SchoolDetails> data = await _smsManager.getSchoolDetails();
    schoolDetails = data;
    apiKey = schoolDetails[0].smsKey;
    smsId = schoolDetails[0].smsID;
    String url = 'https://payments.africastalking.com/query/wallet/balance?username=mgpatto';

    final response = await client.get(
      url,
      headers: {"apiKey": "0e33d3656655659ffcde61e3b34b215f930a9905d3548d897b4504b2b679c1a5"},
    );
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      saveBalance(result['status']);
      String bal = result['status'];
      print(bal);
    } else {
      throw Exception('failed to show balance');
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
