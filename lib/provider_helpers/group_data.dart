import 'package:flutter/foundation.dart';

import 'package:mcpoc/models/group.dart';
import 'dart:collection';

// OrgData Class: This class is the interface controller between Provider and the list of organizations
// The class it comprised of two lists and associated helper functions. One list retains ALL orgs to which a user can connect
// and a second list contains the orgs to which a user elects to connect with.
class GroupData extends ChangeNotifier {
  // This list contains all eligible orgs for the user
  List<Group> _groups = [
    /*Org(
        orgName: 'SDA Ooltewah',
        orgLocation: 'Ooltewah, TN',
        unreadMessages: 0),
 */
  ];

  // This list contains all orgs selected by the user
  List<Group> _activeGroups = [];

  //BEGIN: Support functions for the master org list -----------------------
  //This is a type that allows us to look at a ListView through a virtual window.. necessary because the list is a private property
  UnmodifiableListView<Group> get groups {
    return UnmodifiableListView(_groups);
  }

  int get groupCount {
    return _groups.length;
  }

  //TODO: modify this functionality to build the users selected list from the available list
  void addGroup(String groupName) {
    final group = Group(
      groupName: groupName
    );

    // Add to the user's trusted org list
    _groups.add(group);

    notifyListeners();
  }

  void clearGroupList() {
    _groups.clear();
  }

  //END: Support functions for the master org list -----------------------------

  //BEGIN: Support functions for the active org list ---------------------------

  UnmodifiableListView<Group> get activeGroups {
    return UnmodifiableListView(_activeGroups);
  }

  int get getActiveGroupCount {
    return _activeGroups.length;
  }
  //END: Support functions for the active org list -----------------------------

  void updateSelection(Group group) {
    group.toggleDone();
    notifyListeners();
  }

  //Function to clear and build the _active_orgs list based on user selection.
  //Active orgs are those the user has selected for engagement
  void buildActiveGroupList() {
    _activeGroups.clear();
    for (Group group in _groups) {
      _activeGroups.add(group);
    }
  }
}