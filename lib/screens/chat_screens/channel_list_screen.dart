import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sch;
import 'package:mcpoc/screens/chat_screens/channel_list.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

// import 'channel_list.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({
    Key? key,
  }) : super(key: key);

  static const String id = 'channel_list_screen';

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  int _currentIndex = 0;

  bool _isSelected(int index) => _currentIndex == index;

  @override
  Widget build(BuildContext context) {
    final chatClient = sch.StreamChat.of(context).client;
    final user = chatClient.state.currentUser;
    if (user == null) {
      return Offstage();
    }
    return Scaffold(
      backgroundColor: sch.StreamChatTheme.of(context).colorTheme.appBg,
      // appBar: sch.ChannelListHeader(
      //   onNewChatButtonTap: () {
      //     // Navigator.pushNamed(context, Routes.NEW_CHAT);
      //   },
      //   preNavigationCallback: () {
      //     FocusScope.of(context).requestFocus(FocusNode());
      //   },
      // ),
      drawerEdgeDragWidth: 50,
      body: IndexedStack(
        index: _currentIndex,
        children: [ChannelList()],
      ),
    );
  }

  StreamSubscription<int>? badgeListener;

  @override
  void initState() {
    if (!kIsWeb) {
      badgeListener = sch.StreamChat.of(context)
          .client
          .state
          .totalUnreadCountStream
          .listen((count) {
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    badgeListener?.cancel();
    super.dispose();
  }
}
