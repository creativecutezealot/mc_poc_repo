import 'package:flutter/material.dart';
import 'package:mcpoc/home_screen/home_dashboard.dart';
import 'package:mcpoc/provider_helpers/group_data.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/provider_helpers/org_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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

    // print("About to call function");
    // try {
    //   HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    //       'getUserOrgs?uid=' +
    //           Uri.encodeComponent(_auth.currentUser.phoneNumber));
    //   dynamic resp = await callable.call();
    //   // print("phone:");
    //   // print(_auth.currentUser.phoneNumber);
    //   // print("response:");
    //   // print(resp.data);
    //   resp.data.forEach(
    //     (orgInfo) {
    //       print("Org:");
    //       print(orgInfo);
    //
    //       // Update the UI with the query results by adding them to the master org list
    //       Provider.of<OrgData>(context, listen: false).addOrg(
    //         orgInfo['orgName'],
    //         orgInfo['orgLocation'],
    //         false,
    //         orgInfo['orgId'],
    //       );
    //     },
    //   );
    //   // Once we've added all the orgs, build the separate active org list
    //   Provider.of<OrgData>(context, listen: false).buildActiveOrgList();
    // } catch (e) {
    //   print("Error while calling function.");
    //   print(e);
    // }

    // Call the getUserActiveOrgs
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'getUserActiveOrgs?uid=' +
              Uri.encodeComponent(_auth.currentUser!.phoneNumber as String));
      dynamic resp = await callable.call();
      // print("phone:");
      // print(_auth.currentUser.phoneNumber);
      print("response:");
      print(resp.data['trusted_orgs']);
      resp.data['trusted_orgs'].forEach(
        (orgInfo) {
          // Update the UI with the query results by adding them to the master org list
          Provider.of<OrgData>(context, listen: false).addOrg(
            orgInfo['org_name'],
            orgInfo['location'],
            orgInfo['is_active'],
            orgInfo['org_id'],
          );
        },
      );
      // Once we've added all the orgs, build the separate active org list
      Provider.of<OrgData>(context, listen: false).buildActiveOrgList();
    } catch (e) {
      print("Error while calling function.");
      print(e);
    }
  }

  static List<Widget> _bodyOptions = <Widget>[
    HomeDashboard(),
    Text(
      'Index 2: Favorites',
    ),
    Text(
      'Index 3: Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
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
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            //TODO: Change HomeScreen menu action from 'back' to context menu
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Your Trusted Orgs',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
            onPressed: () {
              //TODO: handle plus button action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _bodyOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Orgs',
            icon: Icon(Icons.business),
          ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
