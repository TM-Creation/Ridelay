import 'package:flutter/material.dart';

class DebugHelper {
  static printAll(dynamic data) {
    debugPrint(data.toString(), wrapWidth: 1024);
  }
}
