import 'package:flutter/foundation.dart';
import 'package:mcpoc/models/channel.dart';
import 'dart:collection';

// TopicData Class: This class is the interface controller between Provider and the list of organizations
// The class it comprised of two lists and associated helper functions. One list retains ALL orgs to which a user can connect
// and a second list contains the orgs to which a user elects to connect with.
class ChannelData extends ChangeNotifier {
  late String _orgName;
  late String _orgID;

  // This list contains all topics available to the user in the given org
  List<Channel> _channels = [
    Channel(
        channelName: 'Fall Camp Trip',
        isOrgChannel: true,
        unreadMessages: 2,
        lastMessageTime: DateTime.now()),
    Channel(
        channelName: 'Driving to event',
        isOrgChannel: false,
        unreadMessages: 1,
        lastMessageTime: DateTime.now()),
    Channel(
        channelName: 'Update on 2020 Dues',
        isOrgChannel: true,
        unreadMessages: 0,
        lastMessageTime: DateTime.now()),
  ];

  //BEGIN: Support functions for the master org list -----------------------
  //This is a type that allows us to look at a ListView through a virtual window.. necessary because the list is a private property
  UnmodifiableListView<Channel> get channels {
    return UnmodifiableListView(_channels);
  }

  void addChannel(
      String channelName, int unreadMessages, DateTime lastMessageTime) {
    final channel = Channel(
        channelName: channelName,
        unreadMessages: unreadMessages,
        lastMessageTime: lastMessageTime);

    _channels.add(channel);

    //TODO: first get the data synced with GCP, then assess updating notifyListeners
    notifyListeners();
  }

  //get the number of channels available to the user
  int get channelCount {
    return _channels.length;
  }

  set orgName(String name) {
    _orgName = name;
  }

  String get orgName {
    return _orgName;
  }

  set orgID(String id) {
    _orgID = id;
  }

  String get orgID {
    return _orgID;
  }

  void clearChannelList() {
    _channels.clear();
  }

  void updateUnreadMessageCount(Channel channel, int unreadMessages) {
    channel.updateUnreadMessages(unreadMessages);
    notifyListeners();
  }
}
