import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:walgotech_final/database/database.dart';

class CurrentStreams {
  String streamName;

  CurrentStreams({
    @required this.streamName,
  });

  Map<String, dynamic> toMap() {
    return {
      StreamsManager.streamName: streamName,
    };
  }

  factory CurrentStreams.fromJson(Map<String, dynamic> json) {
    return new CurrentStreams(
      streamName: json[StreamsManager.streamName],
    );
  }
}
