import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';
class SMS {
  int id;
  String message;
  String dateTime;
  String sender;
  String recipent;

  SMS({id, @required this.message, @required this.sender, @required this.dateTime, this.recipent});

  Map<String, dynamic> toMap() {
    return {
      SmsManager.id:id,
      SmsManager.message: message,
      SmsManager.date: dateTime,
      SmsManager.sender: sender,
      SmsManager.recipent: recipent
    };
  }

  factory SMS.fromJson(Map<String, dynamic> json) {
    return new SMS(
        id: json[SmsManager.id],
        message: json[SmsManager.message],
        sender: json[SmsManager.sender],
        dateTime: json[SmsManager.date],
        recipent: json[SmsManager.recipent]);
  }
}
