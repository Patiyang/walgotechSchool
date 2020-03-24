import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class Contacts {
  String motherNumber;
  String fatherNumber;
  String guardianNumber;
  String form;

  Contacts(
      {@required this.motherNumber,
      @required this.fatherNumber,
      @required this.guardianNumber,
      @required this.form});

  Map<String, dynamic> toMap() {
    return {
      ContactsManager.fatherNumber: fatherNumber,
      ContactsManager.motherNumber: motherNumber,
      ContactsManager.guardianNumber: guardianNumber,
      ContactsManager.form: form
    };
  }

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return new Contacts(
        fatherNumber: json[ContactsManager.fatherNumber],
        motherNumber: json[ContactsManager.motherNumber],
        guardianNumber: json[ContactsManager.guardianNumber],
        form: json[ContactsManager.form]);
  }
}
