import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/blocs/userBloc.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:walgotech_final/helperClasses/button.dart';
import 'package:walgotech_final/models/schoolDetails.dart';
import 'package:walgotech_final/resources/APIProvider.dart';
import 'package:walgotech_final/styling.dart';

class Login extends StatefulWidget {
  final VoidCallback loginPressed;

  const Login({Key key, this.loginPressed}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DBManagement _dbManagement = DBManagement();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final userName = new TextEditingController();
  final password = new TextEditingController();
  @override
  void initState() {
    super.initState();
    saveSchoolDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: primaryColor,
      body: ListView(
        // addAutomaticKeepAlives: true,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Welcome\n Back',
                style: register,
                // textAlign: TextAlign.start,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) return 'invalid userName';
                        return null;
                      },
                      controller: userName,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'UserName',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty)
                          return 'password cannot be empty';
                        else if (value.length < 6) return 'passowrd has to be at least 6 characters';
                        return null;
                      },
                      controller: password,
                      obscureText: true,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * .4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Sign In',
                    style: signIn,
                  ),
                  CustomButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: primaryColor,
                      ),
                      callback: () async {
                        await signInValidate();
                      }),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text('Powered By'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'WALGOTECH',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  signInValidate() async {
    if (formKey.currentState.validate()) {
      Fluttertoast.showToast(msg: 'User Not Found');
      await userBloc.signInUser(userName.text, password.text).then((_) => widget.loginPressed());
      Fluttertoast.showToast(msg: 'Login Success');
    } else {
      Fluttertoast.showToast(msg: 'Please Check your credentials');
    }
  }

  saveSchoolDetails(BuildContext context) async {
    Client client = Client();
    final SmsManager smsManager = new SmsManager();
    String url = 'http://192.168.122.1:8000/backend/operations/readSchoolDetails.php';

    final response = await client.get(url);
    final Map result = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (int i = 0; i < result['school'].length; i++) {
        SchoolDetails school = new SchoolDetails(
            schoolName: result['school'][i]['schoolName'],
            smsID: result['school'][i]['smsKey'],
            smsKey: result['school'][i]['smsID']);
        smsManager.addSchool(school).then((school) => print('$school has been added'));
        saveSchoolName(result['school'][i]['schoolName']);
      }
    } else {
      throw Exception('failed to add school');
    }
  }

  saveSchoolName(String schoolName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('schoolName', schoolName);
  }
}
