import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:walgotech_final/database/database.dart';
import 'package:walgotech_final/models/contacts.dart';

// class StudentSearch extends StatefulWidget {
//   @override
//   _StudentSearchState createState() => _StudentSearchState();
// }

// class _StudentSearchState extends State<StudentSearch> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GradientAppBar(
//         elevation: 0,
//         gradient: LinearGradient(colors: [Colors.cyan, Colors.indigo]),
//         centerTitle: true,
//         title: Text('Send Group Message'),
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 showSearch(context: context, delegate: DataSearch());
//               })
//         ],
//       ),
//       body: Text('data'),
//     );
//   }
// }

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
        groupContacts.clear();
        customList.clear();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results based on the selections
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: customList.length, //PICK UP FROM HERE
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(parentContact[index].admission),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(parentContact[index].form),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(parentContact[index].studentName),
                        )
                      ],
                    )
                  ])
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    @override
    final suggestionList = query.isEmpty ? recents : groupContacts.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        getParentContacts();
        return ListTile(
          onTap: () {
            customList.add(parentContact[index]);
            groupContacts.clear();
            suggestionList.clear();
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
      groupContacts.add(parentContact[i].admission);
    }
  }
}
