import 'package:shared_preferences/shared_preferences.dart';

class GetClasses {
  getClasses(List<String> streams) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    streams = prefs.getStringList('streams');
  }
}
