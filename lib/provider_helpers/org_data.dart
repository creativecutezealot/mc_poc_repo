import 'package:flutter/foundation.dart';

import 'package:mcpoc/models/org.dart';
import 'dart:collection';

// OrgData Class: This class is the interface controller between Provider and the list of organizations
// The class it comprised of two lists and associated helper functions. One list retains ALL orgs to which a user can connect
// and a second list contains the orgs to which a user elects to connect with.
class OrgData extends ChangeNotifier {
  // This list contains all eligible orgs for the user
  List<Org> _orgs = [
    /*Org(
        orgName: 'SDA Ooltewah',
        orgLocation: 'Ooltewah, TN',
        unreadMessages: 0),
 */
  ];

  // This list contains all orgs selected by the user
  List<Org> _activeOrgs = [];

  //BEGIN: Support functions for the master org list -----------------------
  //This is a type that allows us to look at a ListView through a virtual window.. necessary because the list is a private property
  UnmodifiableListView<Org> get orgs {
    return UnmodifiableListView(_orgs);
  }

  int get orgCount {
    return _orgs.length;
  }

  //TODO: modify this functionality to build the users selected list from the available list
  void addOrg(String orgName, String orgLocation, bool isActive, String orgID) {
    final org = Org(
        orgName: orgName,
        orgLocation: orgLocation,
        isChecked: isActive,
        orgID: orgID, unreadMessages: 0);

    // Add to the user's trusted org list
    _orgs.add(org);

    notifyListeners();
  }

  void clearOrgList() {
    _orgs.clear();
  }

  //END: Support functions for the master org list -----------------------------

  //BEGIN: Support functions for the active org list ---------------------------

  UnmodifiableListView<Org> get activeOrgs {
    return UnmodifiableListView(_activeOrgs);
  }

  void updateUnreadMessageCount(Org org, int unreadMessages) {
    org.updateUnreadMessages(unreadMessages);
    notifyListeners();
  }

  int get getActiveOrgCount {
    return _activeOrgs.length;
  }
  //END: Support functions for the active org list -----------------------------

  void updateSelection(Org org) {
    org.toggleDone();
    notifyListeners();
  }

  //Function to clear and build the _active_orgs list based on user selection.
  //Active orgs are those the user has selected for engagement
  void buildActiveOrgList() {
    _activeOrgs.clear();
    for (Org org in _orgs) {
      if (org.isChecked == true) {
        _activeOrgs.add(org);
      }
    }
  }
}
