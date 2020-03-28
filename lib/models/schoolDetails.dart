import 'package:flutter/widgets.dart';
import 'package:walgotech_final/database/database.dart';

class SchoolDetails {
  String schoolName;
  String smsKey;
  String smsID;

  SchoolDetails({
    @required this.schoolName,
    @required this.smsKey,
    @required this.smsID,
  });

  Map<String, dynamic> toMap() {
    return {
      SchoolManager.schoolName: schoolName,
      SchoolManager.smsKey: smsKey,
      SchoolManager.smsID: smsID,
    };
  }
}
