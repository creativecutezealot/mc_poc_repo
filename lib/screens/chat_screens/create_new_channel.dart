import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/screens/chat_screens/new_chat_screen.dart';
import 'package:mcpoc/screens/chat_screens/new_group_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as sch;

class CreateNewChannel extends StatelessWidget {
  static const String id = 'create_new_channel';
  String? newTopicName;
  String? newTopicType;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = sch.StreamChat.of(context).currentUser;
    print('user: ');
    print(user);
    return Container(
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New message',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: sch.StreamSvgIcon.penWrite(
                        // color: sch.StreamChatTheme.of(context)
                        //     .colorTheme
                        //     .textHighEmphasis
                        //     .withOpacity(.5),
                        ),
                    onTap: () {
                      print('create new channel context: ');
                      print(sch.StreamChat.of(context).client);
                      Navigator.popAndPushNamed(
                        context,
                        NewChatScreen.id,
                        arguments: NewChatScreenArgs(
                          sch.StreamChat.of(context).client
                        ),
                      );
                    },
                    title: Text(
                      'New direct message',
                      style: TextStyle(
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: sch.StreamSvgIcon.contacts(
                        // color: sch.StreamChatTheme.of(context)
                        //     .colorTheme
                        //     .textHighEmphasis
                        //     .withOpacity(.5),
                        ),
                    onTap: () {
                      Navigator.popAndPushNamed(
                        context,
                        NewGroupChatScreen.id,
                        arguments: NewGroupChatScreenArgs(
                          sch.StreamChat.of(context).client
                        ),
                      );
                    },
                    title: Text(
                      'New group',
                      style: TextStyle(
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
