import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/sms.dart';
import 'package:walgotech_final/views/sms/parents/parentsHistory.dart';
import '../../../styling.dart';
import '../SMS.dart';

class ParentsCategory extends StatefulWidget {
  @override
  _ParentsCategoryState createState() => _ParentsCategoryState();
}

class _ParentsCategoryState extends State<ParentsCategory> {
  SMS sms;
  final SmsManager _smsManager = new SmsManager();
  final messageController = new TextEditingController();
  final recipentController = new TextEditingController();
  final formKey = new GlobalKey<FormState>();
  final recipent = <String>[];
  List<String> _contacts;

//drop down variables
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<String> parentsCategories = <String>[
    'Individual Contacts',
    'All Parents',
    'Form4',
    'Form3',
    'Form2',
    'Form1',
  ];
  String _currentCategory = 'category';
  void initState() {
    print(parentsCategories);
    super.initState();
    categoriesDropDown = _getCategoriesDropDown();
    _getCategories();
    changeSelectedCategory(_currentCategory);
    loadContacts();
    _contacts = [];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              MaterialButton(
                  height: 50,
                  color: Colors.white54,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.refresh,
                        size: 30,
                      ),
                      Text('Update Contacts')
                    ],
                  ),
                  onPressed: () {
                    loadContacts();
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Material(
                    elevation: 0,
                    color: Colors.black26,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton(
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_downward,
                          color: Colors.black26,
                        ),
                        hint: Text('Select Category'),
                        items: categoriesDropDown,
                        onChanged: changeSelectedCategory,
                        value: _currentCategory,
                      ),
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(

                        readOnly:_currentCategory==parentsCategories[0]?false: true,
                        maxLines: 4,
                        controller: messageController,
                        validator: (v) => v.isNotEmpty ? null : 'message is empty',
                        decoration: InputDecoration(
                            hintText:_currentCategory==parentsCategories[1]? '$_contacts':'pick contact above',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    MaterialButton(
                        elevation: 0,
                        color: accentColor,
                        child: Text(
                          'Send to both parents',
                          style: categoriesStyle,
                        ),
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          setState(() {});
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 6,
                        controller: recipentController,
                        validator: (v) => v.isNotEmpty ? null : 'recipents are empty',
                        decoration: InputDecoration(
                          enabled: true,
                          hintText: 'Type in Message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      minWidth: MediaQuery.of(context).size.width * .6,
                      child: Text(
                        'send',
                        style: categoriesStyle,
                      ),
                      onPressed: () {
                        sendMessage(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: accentColor,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        minWidth: MediaQuery.of(context).size.width * .6,
                        child: Text(
                          'View History',
                          style: categoriesStyle,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ParentHistory()));
                        },
                      ),
                    ),
                  ],
                ),
              )
              // SendMessage()
            ],
          ),
        ),
      ),
    );
  }

  void loadContacts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _contacts = preferences.getStringList('contacts');
    setState(() {
      _contacts = preferences.getStringList('contacts');
      print(_contacts.toString());
    });
  }

  void sendMessage(BuildContext context) {
    if (formKey.currentState.validate()) {
      if (sms == null) {
        SMS sms = new SMS(
          message: messageController.text,
          sender: recipentController.text,
          recipent: _currentCategory,
          dateTime: DateTime.now().toString(),
        );
        _smsManager.insertSMS(sms).then((id) =>
            {messageController.clear(), recipentController.clear(), print('Student added to DB $id')});
      }
    }
  }

  List<DropdownMenuItem<String>> _getCategoriesDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = new List();
    print(parentsCategories.length);
    for (int i = 0; i < parentsCategories.length; i++) {
      setState(() {
        if (parentsCategories.length == 0 || categoriesStyle == null) {
          Text('Absent');
        }
        dropDownItems.insert(
            0,
            DropdownMenuItem(
              child: Text(parentsCategories[i]),
              value: parentsCategories[i],
            ));
      });
    }
    return dropDownItems;
  }

  _getCategories() async {
    setState(() {
      categoriesDropDown = _getCategoriesDropDown();
      _currentCategory = parentsCategories[0];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
      print(_currentCategory);
    });
  }
}
