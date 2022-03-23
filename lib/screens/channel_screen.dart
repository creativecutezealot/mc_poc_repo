import 'package:flutter/material.dart';
import 'package:mcpoc/helpers/route_helper.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/provider_helpers/group_data.dart';
import 'package:mcpoc/screens/add_member_screen.dart';
import 'package:mcpoc/screens/chat_screens/channel_list_screen.dart';
import 'package:mcpoc/widgets/active_org_list.dart';
import 'package:mcpoc/widgets/channel_list.dart';
import 'package:mcpoc/screens/message_screens/add_topic_screen.dart';
import 'package:mcpoc/screens/chat_screens/create_new_channel.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/constants.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sch;

class ChannelScreen extends StatefulWidget {
  static const String id = 'topic_screen';
  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  final searchTextController = TextEditingController();
  String? searchText;
  int _selectedIndex = 0;
  var bottomNavIndex = {
    'orgTab': 0,
    'groupTab': 1,
    'directTab': 2,
    'defaultTab': 0
  };
  InitData? _initData;
  bool _isAdmin = false;

  final client = sch.StreamChatClient(
    'advfqw5qsj69',
    logLevel: sch.Level.INFO,
  );

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  Future<void> initScreenData() async {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print(user.metadata);
        }
      },
    );

    Provider.of<ChannelData>(context, listen: false).clearChannelList();
    Provider.of<GroupData>(context, listen: false).clearGroupList();

    print("About to call getUserChannels function using...");
    print("phone:");
    print(FirebaseAuth.instance.currentUser!.phoneNumber);
    print(Uri.encodeComponent(
        FirebaseAuth.instance.currentUser!.phoneNumber as String));
    print('Org:');
    print(Provider.of<ChannelData>(context, listen: false).orgID);
    print(Uri.encodeComponent(
        Provider.of<ChannelData>(context, listen: false).orgName));
    print('getUserChannels?uid=' +
        Uri.encodeComponent(
            FirebaseAuth.instance.currentUser!.phoneNumber as String) +
        '&orgId=' +
        Uri.encodeComponent(
            Provider.of<ChannelData>(context, listen: false).orgName));
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getUserChannels?uid=' +
            Uri.encodeComponent(
                FirebaseAuth.instance.currentUser!.phoneNumber as String) +
            '&orgId=' +
            Uri.encodeComponent(
                Provider.of<ChannelData>(context, listen: false).orgName),
      );
      dynamic resp = await callable.call();
      HttpsCallable callable1 = FirebaseFunctions.instance.httpsCallable(
        'getGroups?orgId=' +
            Uri.encodeComponent(
                Provider.of<ChannelData>(context, listen: false).orgName)
      );
      dynamic resp1 = await callable1.call();
      print("response:");
      print(resp.data['userGroups']);
      _isAdmin = resp.data['userGroups'].contains('admin');
      print(_isAdmin);
      resp.data['userAllowedChannels'].forEach(
        (channelInfo) {
          print("Channel:");
          print(channelInfo);

          // Update the UI with the query results by adding them to the master org list
          Provider.of<ChannelData>(context, listen: false).addChannel(
            channelInfo,
            0,
            DateTime.now(),
          );
        },
      );
      resp1.data['data']['groups_list'].forEach((groupInfo) {
        print('groupInfo: ');
        print(groupInfo);
        Provider.of<GroupData>(context, listen: false).addGroup(groupInfo);
      });
      Provider.of<GroupData>(context, listen: false).buildActiveGroupList();
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        String? userId =
            Provider.of<ChannelData>(context, listen: false).orgID +
                '-' +
                (FirebaseAuth.instance.currentUser?.uid as String);
        await client.disconnectUser();
        String? token = client.devToken(userId).rawValue;
        await client.connectUser(sch.User(id: userId), token);
        _initData = InitData(client);
        print("Stream client connected: ");
        print(userId);
      }
    } catch (e) {
      print("Error while calling function.");
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreenData();
  }

  FloatingActionButton newTopicActionButton(BuildContext context, int index) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          // isScrollControlled allows us to position the bottom sheet above the keyboard
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: sch.StreamChat(
                client: _initData!.client,
                child: WillPopScope(
                  onWillPop: () async {
                    final canPop =
                        await _navigatorKey.currentState?.maybePop() ?? false;
                    return !canPop;
                  },
                  child: CreateNewChannel()
                ),
                streamChatThemeData: sch.StreamChatThemeData( 
                  colorTheme: sch.ColorTheme.light( 
                    accentInfo: const Color(0xffffe072),
                  ),
                  brightness: Theme.of(context).brightness,
                )
              ),
              
            ),
          ),
        );
      },
      label: Text('New Channel'),
      icon: Icon(Icons.edit),
      backgroundColor: Colors.lightBlue,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _bodyOptions = <Widget>[
      ChannelList(getOrgTopic: true),
      sch.StreamChat(
        client: client,
        child: ChannelListScreen(),
        streamChatThemeData: sch.StreamChatThemeData( 
          colorTheme: sch.ColorTheme.light( 
            accentInfo: const Color(0xffffe072),
          ),
          brightness: Theme.of(context).brightness,
        )
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: Icon(Icons.add, color: kTileIconColor),
            onTap: () {
              print('create new channel context: ');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMemberScreen()),
              );
            },
            title: Text(
              'Add Members',
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
            trailing: Icon(Icons.navigate_next, color: kTileIconColor),
          ),
          ListTile(
            leading: Icon(Icons.group_add, color: kTileIconColor),
            onTap: () {
              // Navigator.popAndPushNamed(
              //   context,
              //   NewGroupChatScreen.id,
              //   arguments: NewGroupChatScreenArgs(
              //     sch.StreamChat.of(context).client
              //   ),
              // );
            },
            title: Text(
              'Add Org Channels',
              style: TextStyle(
                fontSize: 14.5,
              ),
            ),
            trailing: Icon(Icons.navigate_next, color: kTileIconColor),
          ),
        ],
      ),
    ];
    List<Widget> _searchBarOptions = <Widget>[
      SearchBar(
        searchTextController: searchTextController,
      ),
      Container(color: Colors.white),
      Container(color: Colors.white)
    ];

    List<Widget> _titleOptions = <Widget>[
      Text(
        Provider.of<ChannelData>(context, listen: false).orgName,
      ),
      Text(
        Provider.of<ChannelData>(context, listen: false).orgName,
      ),
      Text(
        'Org Settings',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            //TODO: Change HomeScreen menu action from 'back' to context menu
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Container(
          child: Column(
            children: [_titleOptions.elementAt(_selectedIndex)],
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  // isScrollControlled allows us to position the bottom sheet above the keyboard
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTopicScreen(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _searchBarOptions.elementAt(_selectedIndex),
            Expanded(
              child: Container(
                child: _bodyOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
      ),
      //Do not show the floating action button for the Org tab
      floatingActionButton: bottomNavIndex['groupTab'] == _selectedIndex
          ? newTopicActionButton(context, _selectedIndex)
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Org',
            icon: Icon(Icons.business),
          ),
          BottomNavigationBarItem(
            label: 'Direct Messages',
            icon: Icon(Icons.group),
          ),
          if (_isAdmin)
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

class SearchBar extends StatelessWidget {
  SearchBar({
    Key? key,
    required this.searchTextController,
  }) : super(key: key);

  final TextEditingController searchTextController;
  String? searchText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kMargin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[700] as Color),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: searchTextController,
              onChanged: (value) {
                searchText = value;
                print(searchText);
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey[700],
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class InitData {
  sch.StreamChatClient client;
  InitData(this.client);
}
