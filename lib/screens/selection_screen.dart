import 'package:flutter/material.dart';
import 'package:mcpoc/screens/home_screen.dart';
import 'package:mcpoc/widgets/master_org_list.dart';
import 'package:mcpoc/screens/welcome_screen.dart';
import 'package:mcpoc/provider_helpers/org_data.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/components/rounded_button.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class SelectionScreen extends StatefulWidget {
  static const String id = 'selection_screen';
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}
//TODO: Add info bubble content
//TODO: Read info bubble content from cloud

class _SelectionScreenState extends State<SelectionScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> initScreenData() async {
    _auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          loggedInUser = user;
          print(loggedInUser!.metadata);
        }
      },
    );

    Provider.of<OrgData>(context, listen: false).clearOrgList();

    print("About to call function");
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'getUserOrgs?uid=' +
              Uri.encodeComponent(_auth.currentUser!.phoneNumber as String));
      dynamic resp = await callable.call();
      // print("phone:");
      // print(_auth.currentUser.phoneNumber);
      // print("response:");
      // print(resp.data);
      resp.data.forEach(
        (orgInfo) {
          // print("Org:");
          // print(orgInfo);

          // Update the UI with the query results by adding them to the master org list
          Provider.of<OrgData>(context, listen: false).addOrg(
            orgInfo['orgName'],
            orgInfo['orgLocation'],
            false,
            orgInfo['orgId'],
          );
        },
      );
    } catch (e) {
      print("Error while calling function.");
      print(e);
    }
  }

  // This function pushes the org selections with Cloud Firestore for the given user
  Future<void> setTrustedOrgs() async {
    for (var orgData in Provider.of<OrgData>(context, listen: false).orgs) {
      try {
        _firestore
            .collection('users')
            .doc('${loggedInUser!.phoneNumber}')
            .collection('trusted_orgs')
            .doc(orgData.orgName)
            .set({
          'is_active': orgData.isChecked,
          'location': orgData.orgLocation,
          'org_id': orgData.orgID,
          'org_name': orgData.orgName,
        });
      } catch (e) {
        print(e);
      }
    }
    // Builds the active org list based on the current selection
    Provider.of<OrgData>(context, listen: false).buildActiveOrgList();
  }

  //Debug function
  void printOrgData() {
    print(
        'OrgData array size: ${Provider.of<OrgData>(context, listen: false).orgCount}');

    for (var orgData in Provider.of<OrgData>(context, listen: false).orgs) {
      print(
          'setTrustedOrgs: ${orgData.orgName} is set to ${orgData.isChecked}');
    }
  }

  @override
  void initState() {
    super.initState();
    initScreenData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Orgs',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //messagesStream();
              _auth.signOut();
              Navigator.popUntil(
                  context, ModalRoute.withName(WelcomeScreen.id));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: MasterOrgList(
                  isSetupTile: true,
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        RoundedButton(
          color: Colors.blueAccent,
          buttonTitle: 'Save & Continue',
          onPressed: () {
            _firestore
                .collection('users')
                .doc('${loggedInUser!.phoneNumber}')
                .set({
              'user_id': loggedInUser!.email,
              'user_phone_number': loggedInUser!.phoneNumber,
              'first_login': false,
              'timestamp': DateTime.now().toIso8601String().toString(),
            });
            setTrustedOrgs();
            Navigator.pushNamed(context, HomeScreen.id);
          },
        ),
      ],
    );
  }
}
