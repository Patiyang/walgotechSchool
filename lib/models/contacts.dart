import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class ParentsContacts {
  String motherNumber;
  String fatherNumber;
  String guardianNumber;
  String form;

  ParentsContacts(
      {@required this.motherNumber,
      @required this.fatherNumber,
      @required this.guardianNumber,
      @required this.form});

  Map<String, dynamic> toMap() {
    return {
      ParentsContactsManager.fatherNumber: fatherNumber,
      ParentsContactsManager.motherNumber: motherNumber,
      ParentsContactsManager.guardianNumber: guardianNumber,
      ParentsContactsManager.form: form
    };
  }

  factory ParentsContacts.fromJson(Map<String, dynamic> json) {
    return new ParentsContacts(
        fatherNumber: json[ParentsContactsManager.fatherNumber],
        motherNumber: json[ParentsContactsManager.motherNumber],
        guardianNumber: json[ParentsContactsManager.guardianNumber],
        form: json[ParentsContactsManager.form]);
  }
}

class TeacherContacts {
  String firstName;
  String lastName;
  String phoneNumber;
  TeacherContacts({
    @required this.firstName,
    @required this.lastName,
    @required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      TeacherManager.firstName: firstName,
      TeacherManager.lastName: lastName,
      TeacherManager.phoneNumber: phoneNumber,
    };
  }

  factory TeacherContacts.fromJson(Map<String, dynamic> json) {
    return new TeacherContacts(
      firstName: json[TeacherManager.firstName],
      lastName: json[TeacherManager.lastName],
      phoneNumber: json[TeacherManager.phoneNumber],
    );
  }
}
