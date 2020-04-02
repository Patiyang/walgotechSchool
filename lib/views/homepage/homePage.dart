import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/helperClasses/error.dart';
import 'package:walgotech_final/helperClasses/loading.dart';
import 'package:walgotech_final/models/schoolDetails.dart';
import 'package:walgotech_final/styling.dart';
import 'package:walgotech_final/views/login/login.dart';
import 'carousel.dart';
import 'modules.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SmsManager _smsManager = new SmsManager();
  List<SchoolDetails> schoolDetails = <SchoolDetails>[];
  String name = '';
  String schoolName = '';
  @override
  void initState() {
    signInUser();
    name = '';
    getSchoolName();
    super.initState();
  }

  // _HomePageState();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: signInUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          name = snapshot.data;
          print(snapshot.connectionState.toString());
          return name.length > 0 ? getHomePage() : Login(loginPressed: login);
        }
        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }
        return ErrorLog();
      },
    );
  }

  void login() {
    setState(() {
      build(context);
    });
  }

  Future signInUser() async {
    name = await getUName();
    if (name != null) {
      if (name.length > 0) {}
    } else {
      name = '';
    }
    return name;
  }

  Widget getHomePage() {
    return Scaffold(
      appBar: GradientAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/student.jpg'),
          ),
        ),
        title: Text(
          schoolName,
          style: TextStyle(color: Colors.white),
        ),
        gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          ImageCarousel(),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    'images/student.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: accentColor.withOpacity(.7)),
                ),
                Modules()
              ],
            ),
          )
        ],
      ),
    );
  }

  getUName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('userName');
  }

  getSchoolName() async {
    List<SchoolDetails> data = await _smsManager.getSchoolDetails();
    schoolDetails = data;
    setState(() {
      schoolName = schoolDetails[0].schoolName;
    });
    print('object\n\n\n\n\n\n ' + schoolName);
    return schoolName;
  }
}
