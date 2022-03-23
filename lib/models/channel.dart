import 'package:flutter/cupertino.dart';

class Channel {
  Channel(
      {required this.channelName,
      this.isOrgChannel = false,
      this.unreadMessages = 0,
      required this.lastMessageTime});

  final String channelName;
  final bool isOrgChannel;
  int unreadMessages;
  DateTime lastMessageTime;

  void updateUnreadMessages(int newCount) {
    print('new message count: $newCount');
    unreadMessages = newCount;
  }
}
