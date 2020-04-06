import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/contacts.dart';

class StudentSearch extends StatefulWidget {
  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // child: IconButton(
      //     icon: Icon(Icons.search),
      //     onPressed: () {
      //       showSearch(context: context, delegate: DataSearch());
      //     }),
      appBar: GradientAppBar(
        elevation: 0,
        gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
        centerTitle: true,
        title: Text('Send Group Message'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List groupContacts = <String>[];
  List<ParentsContacts> customList = <ParentsContacts>[];
  List recents = ['Search by Admission Number'];
  List<ParentsContacts> parentContact;
  SmsManager _smsManager = SmsManager();
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for the appbar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // what you want to have as the leading icon
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results based on the selections
    return ListView.builder(
      itemCount: customList.length, //PICK UP FROM HERE
      itemBuilder: (BuildContext context, int index) {
        return Text(parentContact[index].guardianNumber);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getParentContacts();
    @override
    final suggestionList = query.isEmpty ? recents : groupContacts.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            customList.add(parentContact[index]);
            showResults(context);
          },
          leading: Icon(Icons.person),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [TextSpan(text: suggestionList[index].substring(query.length), style: TextStyle(color: Colors.grey))]),
          ),
        );
      },
    );
  }

  getParentContacts() async {
    List<ParentsContacts> data = await _smsManager.getAllParentContacts();
    parentContact = data;
    for (int i = 0; i < parentContact.length; i++) {
      groupContacts.insert(0, parentContact[i].admission);
    }
  }
}
