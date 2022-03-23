import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/provider_helpers/org_data.dart';
import 'package:cloud_functions/cloud_functions.dart';

//This class contains the firestore functionality for a session
class FirestoreHelper {
  FirestoreHelper({required BuildContext context}) {
    print('Entered constructor');
    _getCurrentUser();
    _getTrustedOrgs();
  }
  BuildContext? context;
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initialize(BuildContext context) {
    _getCurrentUser();
    _getTrustedOrgs();
  }

  Future<void> _getCurrentUser() async {
    _auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
          loggedInUser = user;
        }
      },
    );
    //     final user = _auth.currentUser();
    // if (user != null) {
    //   loggedInUser = user;
    // }
    // print(loggedInUser.email);
    // //getTrustedOrgs();
  }

  Future<void> _getTrustedOrgs() async {
    //Ensure the cached org list is cleared
    Provider.of<OrgData>(context!, listen: false).clearOrgList();
    print('Entered _getTrustedOrgs');
    //Query the current user org list from Firestore once (get() method) and cache it locally
    var snapshot = await _firestore
        .collection('users')
        .doc(loggedInUser!.phoneNumber)
        .collection('trusted_orgs')
        .get();
    for (var trustedOrg in snapshot.docs) {
      Provider.of<OrgData>(context!, listen: false).addOrg(
        trustedOrg.data()['org_name'],
        trustedOrg.data()['location'],
        trustedOrg.data()['is_active'],
        trustedOrg.data()['org_id'],
      );
    }
  }

  void signOut() {
    _auth.signOut();
  }

  User? get getCurrentUser {
    return loggedInUser;
  }
}
