import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mcpoc/screens/chat_screens/group_chat_details_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sch;

import 'package:mcpoc/components/search_text_field.dart';

class NewGroupChatScreenArgs {
  final sch.StreamChatClient chatClient;

  NewGroupChatScreenArgs(this.chatClient);
}

class NewGroupChatScreen extends StatefulWidget {
  static const String id = 'new_group_chat_screen';
  NewGroupChatScreen({
    Key? key,
    required this.chatClient,
  }) : super(key: key);
  final sch.StreamChatClient chatClient;
  @override
  _NewGroupChatScreenState createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends State<NewGroupChatScreen> {
  TextEditingController? _controller;

  String _userNameQuery = '';

  final _selectedUsers = <sch.User>{};

  bool _isSearchActive = false;

  Timer? _debounce;

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _userNameQuery = _controller!.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_userNameListener);
  }

  @override
  void dispose() {
    _controller?.clear();
    _controller?.removeListener(_userNameListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as NewGroupChatScreenArgs;
    return Scaffold(
      // backgroundColor: sch.StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        elevation: 1,
        // backgroundColor: sch.StreamChatTheme.of(context).colorTheme.barsBg,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: Text(
          'Add Group Members',
          style: TextStyle(
            // color: sch.StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedUsers.isNotEmpty)
            IconButton(
              // icon: sch.StreamSvgIcon.arrowRight(
              //   // color: sch.StreamChatTheme.of(context).colorTheme.accentPrimary,
              // ),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: () async {
                final updatedList = await Navigator.pushNamed(
                  context,
                  GroupChatDetailsScreen.id,
                  arguments: GroupChatDetailsScreenArgs(widget.chatClient, _selectedUsers.toList(growable: false))
                );
                if (updatedList != null) {
                  setState(() {
                    _selectedUsers
                      ..clear()
                      ..addAll(updatedList as Iterable<sch.User>);
                  });
                }
              },
            )
        ],
      ),
      body: sch.StreamChat(
        client: args.chatClient,
        child:sch.ConnectionStatusBuilder(
          statusBuilder: (context, status) {
            String statusString = '';
            bool showStatus = true;

            switch (status) {
              case sch.ConnectionStatus.connected:
                // statusString = AppLocalizations.of(context).connected;
                statusString = 'Connected';
                showStatus = false;
                break;
              case sch.ConnectionStatus.connecting:
                // statusString = AppLocalizations.of(context).reconnecting;
                statusString = 'Reconnecting...';
                break;
              case sch.ConnectionStatus.disconnected:
                // statusString = AppLocalizations.of(context).disconnected;
                statusString = 'Disconnected';
                break;
            }
            return sch.InfoTile(
              showMessage: showStatus,
              tileAnchor: Alignment.topCenter,
              childAnchor: Alignment.topCenter,
              message: statusString,
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: SearchTextField(
                        controller: _controller,
                        hintText: 'Search',
                      ),
                    ),
                    if (_selectedUsers.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          height: 104,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedUsers.length,
                            padding: const EdgeInsets.all(8),
                            separatorBuilder: (_, __) => SizedBox(width: 16),
                            itemBuilder: (_, index) {
                              final user = _selectedUsers.elementAt(index);
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      sch.UserAvatar(
                                        onlineIndicatorAlignment:
                                            Alignment(0.9, 0.9),
                                        user: user,
                                        showOnlineStatus: true,
                                        borderRadius: BorderRadius.circular(32),
                                        constraints: BoxConstraints.tightFor(
                                          height: 64,
                                          width: 64,
                                        ),
                                      ),
                                      Positioned(
                                        top: -4,
                                        right: -4,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_selectedUsers.contains(user)) {
                                              setState(() =>
                                                  _selectedUsers.remove(user));
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: sch.StreamChatTheme.of(context)
                                              //     .colorTheme
                                              //     .appBg,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                // color: sch.StreamChatTheme.of(context)
                                                //     .colorTheme
                                                //     .appBg,
                                              ),
                                            ),
                                            child: sch.StreamSvgIcon.close(
                                              // color: sch.StreamChatTheme.of(context)
                                              //     .colorTheme
                                              //     .textHighEmphasis,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.name.split(' ')[0],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _HeaderDelegate(
                        height: 30,
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            // gradient:
                            //     sch.StreamChatTheme.of(context).colorTheme.bgGradient,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Text(
                              _isSearchActive
                                  ? 'Matches for \"$_userNameQuery\"'
                                  : 'On the platform',
                              style: TextStyle(
                                // color: sch.StreamChatTheme.of(context)
                                //     .colorTheme
                                //     .textLowEmphasis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (_) => FocusScope.of(context).unfocus(),
                  child: sch.UsersBloc(
                    child: sch.UserListView(
                      selectedUsers: _selectedUsers,
                      pullToRefresh: false,
                      groupAlphabetically: _isSearchActive ? false : true,
                      onUserTap: (user, _) {
                        if (!_selectedUsers.contains(user)) {
                          setState(() {
                            _selectedUsers.add(user);
                          });
                        } else {
                          setState(() {
                            _selectedUsers.remove(user);
                          });
                        }
                      },
                      pagination: sch.PaginationParams(
                        limit: 25,
                      ),
                      filter: sch.Filter.and([
                        if (_userNameQuery.isNotEmpty)
                          sch.Filter.autoComplete('name', _userNameQuery),
                        sch.Filter.notEqual(
                            'id', widget.chatClient.state.currentUser!.id),
                      ]),
                      sort: [
                        sch.SortOption(
                          'name',
                          direction: 1,
                        ),
                      ],
                      emptyBuilder: (_) {
                        return LayoutBuilder(
                          builder: (context, viewportConstraints) {
                            return SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight,
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: sch.StreamSvgIcon.search(
                                          size: 96,
                                          // color: sch.StreamChatTheme.of(context)
                                          //     .colorTheme
                                          //     .textLowEmphasis,
                                        ),
                                      ),
                                      Text(
                                        'No user matches these keywords...',
                                        // style: sch.StreamChatTheme.of(context)
                                        //     .textTheme
                                        //     .footnote
                                        //     .copyWith(
                                        //       color: sch.StreamChatTheme.of(context)
                                        //           .colorTheme
                                        //           .textLowEmphasis,
                                        //     ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        streamChatThemeData: sch.StreamChatThemeData( 
          colorTheme: sch.ColorTheme.light( 
            accentInfo: const Color(0xffffe072),
          ),
          brightness: Theme.of(context).brightness,
        )
      )
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _HeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // color: sch.StreamChatTheme.of(context).colorTheme.barsBg,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) => true;
}
