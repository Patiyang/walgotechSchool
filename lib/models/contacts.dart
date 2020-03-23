import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class Contacts {
  int id;
  String number;

  Contacts({id, @required this.number});

  Map<String, dynamic> toMap() {
    return {
      SmsManager.id: id,
      SmsManager.message: number,
    };
  }

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return new Contacts(
      id: json[SmsManager.id],
      number: json[SmsManager.number],
    );
  }
}
