import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class CurrentClasses {

  String registeredClasses;

  CurrentClasses({
    
    @required this.registeredClasses,
  });

  Map<String, dynamic> toMap() {
    return {
      
      ClassesManager.className: registeredClasses,
    };
  }

  factory CurrentClasses.fromJson(Map<String, dynamic> json) {
    return new CurrentClasses(
      registeredClasses: json[ClassesManager.className],
    );
  }
}

class CurrentStreams {
  String streams;

  CurrentStreams({
    @required this.streams,
  });

  Map<String, dynamic> toMap() {
    return {
      StreamsManager.streams: streams,
    };
  }

  factory CurrentStreams.fromJson(Map<String, dynamic> json) {
    return new CurrentStreams(
      streams: json[StreamsManager.streams],
    );
  }
}
