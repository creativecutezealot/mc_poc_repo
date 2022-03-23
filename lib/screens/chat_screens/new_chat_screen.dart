import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mcpoc/screens/chat_screens/channel_page.dart';
import 'package:mcpoc/screens/chat_screens/new_group_chat_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sch;
import 'package:mcpoc/components/chips_input_text_field.dart';

class NewChatScreenArgs {
  final sch.StreamChatClient chatClient;

  NewChatScreenArgs(this.chatClient);
}

class NewChatScreen extends StatefulWidget {
  static const String id = 'new_chat_screen';
  NewChatScreen({
    Key? key,
    required this.chatClient,
  }) : super(key: key);
  final sch.StreamChatClient chatClient;
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _chipInputTextFieldStateKey =
      GlobalKey<ChipInputTextFieldState<sch.User>>();

  late TextEditingController _controller;

  ChipInputTextFieldState? get _chipInputTextFieldState =>
      _chipInputTextFieldStateKey.currentState;

  String _userNameQuery = '';

  final _selectedUsers = <sch.User>{};

  final _searchFocusNode = FocusNode();
  final _messageInputFocusNode = FocusNode();

  bool _isSearchActive = false;

  sch.Channel? channel;

  Timer? _debounce;

  bool _showUserList = true;

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted)
        setState(() {
          _userNameQuery = _controller.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
    });
  }

  @override
  void initState() {
    super.initState();
    // channel = sch.StreamChat.of(context).client.channel('messaging');
    channel = widget.chatClient.channel('messaging');
    _controller = TextEditingController()..addListener(_userNameListener);

    _searchFocusNode.addListener(() async {
      if (_searchFocusNode.hasFocus && !_showUserList) {
        setState(() {
          _showUserList = true;
        });
      }
    });

    _messageInputFocusNode.addListener(() async {
      if (_messageInputFocusNode.hasFocus && _selectedUsers.isNotEmpty) {
        // final chatState = sch.StreamChat.of(context);

        final res = await widget.chatClient.queryChannelsOnline(
          state: false,
          watch: false,
          filter: sch.Filter.raw(value: {
            'members': [
              ..._selectedUsers.map((e) => e.id),
              widget.chatClient.state.currentUser!.id,
            ],
            'distinct': true,
          }),
          messageLimit: 0,
          paginationParams: sch.PaginationParams(
            limit: 1,
          ),
        );

        final _channelExisted = res.length == 1;
        if (_channelExisted) {
          channel = res.first;
          await channel!.watch();
        } else {
          channel = widget.chatClient.channel(
            'messaging',
            extraData: {
              'members': [
                ..._selectedUsers.map((e) => e.id),
                widget.chatClient.state.currentUser!.id,
              ],
            },
          );
        }

        setState(() {
          _showUserList = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _messageInputFocusNode.dispose();
    _controller.clear();
    _controller.removeListener(_userNameListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as NewChatScreenArgs;
    print('args: ');
    print(args.chatClient);
    return Scaffold(
        // backgroundColor: sch.StreamChatTheme.of(context).colorTheme.appBg,
        appBar: AppBar(
          brightness: Theme.of(context).brightness,
          elevation: 0,
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
            'New Chat',
            // style: sch.StreamChatTheme.of(context).textTheme.headlineBold.copyWith(
            //     color: sch.StreamChatTheme.of(context).colorTheme.textHighEmpRhasis),
          ),
          centerTitle: true,
        ),
        body: sch.StreamChat(
          client: args.chatClient,
          child: sch.ConnectionStatusBuilder(
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
                child: sch.StreamChannel(
                  showLoading: false,
                  channel: channel!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChipsInputTextField<sch.User>(
                        key: _chipInputTextFieldStateKey,
                        controller: _controller,
                        focusNode: _searchFocusNode,
                        hint: 'Type a name',
                        chipBuilder: (context, user) {
                          return GestureDetector(
                            onTap: () {
                              _chipInputTextFieldState?.removeItem(user);
                              _searchFocusNode.requestFocus();
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: sch.StreamChatTheme.of(context)
                                        .colorTheme
                                        .disabled,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.only(left: 24),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                                    child: Text(
                                      user.name,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: sch.StreamChatTheme.of(context)
                                            .colorTheme
                                            .textHighEmphasis,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  foregroundDecoration: BoxDecoration(
                                    color: sch.StreamChatTheme.of(context)
                                        .colorTheme
                                        .overlay,
                                    shape: BoxShape.circle,
                                  ),
                                  child: sch.UserAvatar(
                                    showOnlineStatus: false,
                                    user: user,
                                    constraints: BoxConstraints.tightFor(
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                ),
                                sch.StreamSvgIcon.close(),
                              ],
                            ),
                          );
                        },
                        onChipAdded: (user) {
                          setState(() => _selectedUsers.add(user));
                        },
                        onChipRemoved: (user) {
                          setState(() => _selectedUsers.remove(user));
                        },
                      ),
                      if (!_isSearchActive && !_selectedUsers.isNotEmpty)
                        Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                NewGroupChatScreen.id,
                                arguments: NewGroupChatScreenArgs(
                                  widget.chatClient
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  sch.StreamNeumorphicButton(
                                    child: Center(
                                      child: sch.StreamSvgIcon.contacts(
                                        // color: sch.StreamChatTheme.of(context)
                                        //     .colorTheme
                                        //     .accentPrimary,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    // AppLocalizations.of(context).createAGroup,
                                    'Create a Group',
                                    // style: sch.StreamChatTheme.of(context)
                                    //     .textTheme
                                    //     .bodyBold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (_showUserList)
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            // gradient: sch.StreamChatTheme.of(context)
                            //     .colorTheme
                            //     .bgGradient,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Text(
                                _isSearchActive
                                    ? 'Matches for "$_userNameQuery"'
                                    : 'On the platform',
                                style: sch.StreamChatTheme.of(context)
                                    .textTheme
                                    .footnote
                                    .copyWith(
                                        color: sch.StreamChatTheme.of(context)
                                            .colorTheme
                                            .textHighEmphasis
                                            .withOpacity(.5))),
                          ),
                        ),
                      Expanded(
                        child: _showUserList
                            ? GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onPanDown: (_) =>
                                    FocusScope.of(context).unfocus(),
                                child: sch.UsersBloc(
                                  child: sch.UserListView(
                                    selectedUsers: _selectedUsers,
                                    groupAlphabetically:
                                        _isSearchActive ? false : true,
                                    onUserTap: (user, _) {
                                      _controller.clear();
                                      if (!_selectedUsers.contains(user)) {
                                        _chipInputTextFieldState
                                          ?..addItem(user)
                                          ..pauseItemAddition();
                                      } else {
                                        _chipInputTextFieldState!.removeItem(user);
                                      }
                                    },
                                    pagination: sch.PaginationParams(
                                      limit: 25,
                                    ),
                                    filter: sch.Filter.and([
                                      if (_userNameQuery.isNotEmpty)
                                        sch.Filter.autoComplete(
                                            'name', _userNameQuery),
                                      sch.Filter.notEqual(
                                          'id',
                                          sch.StreamChat.of(context)
                                              .currentUser!
                                              .id),
                                    ]),
                                    sort: [
                                      sch.SortOption(
                                        'name',
                                        direction: 1,
                                      ),
                                    ],
                                    emptyBuilder: (_) {
                                      return LayoutBuilder(
                                        builder:
                                            (context, viewportConstraints) {
                                          return SingleChildScrollView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: viewportConstraints
                                                    .maxHeight,
                                              ),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              24),
                                                      child: sch.StreamSvgIcon
                                                          .search(
                                                        size: 96,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      'No user matches these keywords...',
                                                      // style: sch.StreamChatTheme
                                                      //         .of(context)
                                                      //     .textTheme
                                                      //     .footnote
                                                      //     .copyWith(
                                                      //         color: sch.StreamChatTheme
                                                      //                 .of(
                                                      //                     context)
                                                      //             .colorTheme
                                                      //             .textHighEmphasis
                                                      //             .withOpacity(
                                                      //                 .5)),
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
                              )
                            : FutureBuilder<bool>(
                                future: channel!.initialized,
                                builder: (context, snapshot) {
                                  if (snapshot.data == true) {
                                    return sch.MessageListView();
                                  }

                                  return Center(
                                    child: Text(
                                      'No chats here yet...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        // color: sch.StreamChatTheme.of(context)
                                        //     .colorTheme
                                        //     .textHighEmphasis
                                        //     .withOpacity(.5),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      sch.MessageInput(
                        focusNode: _messageInputFocusNode,
                        preMessageSending: (message) async {
                          await channel!.watch();
                          return message;
                        },
                        onMessageSent: (m) {
                          Navigator.pushNamed(
                            context,
                            ChannelPage.id,
                            arguments: ChannelPageArgs(args.chatClient, channel, null),
                          );
                        },
                      ),
                    ],
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
