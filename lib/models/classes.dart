import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class CurrentClasses {
  String id;
  String registeredClasses;

  CurrentClasses({
    @required this.id,
    @required this.registeredClasses,
  });

  Map<String, dynamic> toMap() {
    return {
      ClassesManager.id: id,
      ClassesManager.className: registeredClasses,
    };
  }

  factory CurrentClasses.fromJson(Map<String, dynamic> json) {
    return new CurrentClasses(
      id: json[ClassesManager.id],
      registeredClasses: json[ClassesManager.className],
    );
  }
}
