import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class ParentsContacts {
  String motherNumber;
  String fatherNumber;
  String guardianNumber;
  String form;
  String admission;
  String streams;

  ParentsContacts(
      {@required this.motherNumber,
      @required this.fatherNumber,
      @required this.guardianNumber,
      @required this.form,
      @required this.admission,
      @required this.streams});

  Map<String, dynamic> toMap() {
    return {
      ParentsContactsManager.fatherNumber: fatherNumber,
      ParentsContactsManager.motherNumber: motherNumber,
      ParentsContactsManager.guardianNumber: guardianNumber,
      ParentsContactsManager.form: form,
      ParentsContactsManager.streams: streams,
      ParentsContactsManager.admission:admission
    };
  }


  factory ParentsContacts.fromJson(Map<String, dynamic> json) {
    return new ParentsContacts(
        fatherNumber: json[ParentsContactsManager.fatherNumber],
        motherNumber: json[ParentsContactsManager.motherNumber],
        guardianNumber: json[ParentsContactsManager.guardianNumber],
        form: json[ParentsContactsManager.form],
        admission: json[ParentsContactsManager.admission],
        streams: json[ParentsContactsManager.streams]);
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

class SubOrdinateContact {
  String firstName;
  String lastName;
  String phone;

  SubOrdinateContact({id, @required this.firstName, @required this.lastName, @required this.phone});

  Map<String, dynamic> toMap() {
    return {
      SubOrdinateManager.firstName: firstName,
      SubOrdinateManager.lastName: lastName,
      SubOrdinateManager.phone: phone,
    };
  }

  factory SubOrdinateContact.fromJson(Map<String, dynamic> json) {
    return new SubOrdinateContact(
      firstName: json[SubOrdinateManager.firstName],
      lastName: json[SubOrdinateManager.lastName],
      phone: json[SubOrdinateManager.phone],
    );
  }
}
