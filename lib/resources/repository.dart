
import 'package:walgotech_final/models/users.dart';
import 'package:walgotech_final/resources/APIProvider.dart';

class Repository {
  final apiProvider = DBManagement();
  Future<User> signIn(String userName, String password) =>
   apiProvider.signInUser(userName, password);

   Future addMessage(String phone,String message)=>
   apiProvider.sendMessages(phone, message);
}
