import 'package:flutter/cupertino.dart';

class Group {
  Group(
      {required this.groupName,
      this.isChecked = false});

  final String groupName;
  bool isChecked;

  void toggleDone() {
    isChecked = !isChecked;
  }
  
}
