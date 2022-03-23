import 'package:flutter/cupertino.dart';

class Org {
  Org(
      {required this.orgName,
      required this.orgLocation,
      required this.orgID,
      this.isChecked = false,
      required this.unreadMessages});

  final String orgName;
  final String orgLocation;
  final String orgID;
  bool isChecked;
  int unreadMessages;

  void toggleDone() {
    isChecked = !isChecked;
  }

  void updateUnreadMessages(int newCount) {
    print('new message count: $newCount');
    unreadMessages = newCount;
  }
}
