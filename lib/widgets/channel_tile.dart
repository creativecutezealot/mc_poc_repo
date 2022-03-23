import 'package:flutter/material.dart';
import 'package:mcpoc/constants.dart';
import 'package:mcpoc/screens/message_screens/message_screen.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';

class ChannelTile extends StatelessWidget {
  ChannelTile(
      {required this.channelName,
      required this.isOrgMessage,
      this.unreadMessages = 0,
      required this.lastMessageTime,
      required this.trailingWidgetCallback});

  final String channelName;
  final bool isOrgMessage;
  final int unreadMessages;
  final DateTime lastMessageTime;
  final Function trailingWidgetCallback;

  Widget getTrailingWidget() {
    return Icon(Icons.navigate_next, color: kTileIconColor);
  }

  Widget getLeadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite_outline),
        // Text(
        //   unreadMessages != null ? '$unreadMessages' : '0',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: kTileIconColor,
        //     fontSize: 14.0,
        //     fontWeight:
        //         unreadMessages == 0 ? FontWeight.normal : FontWeight.bold,
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: kMargin,
      child: ListTile(
        leading: getLeadingWidget(),
        title: Text(
          channelName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight:
                unreadMessages > 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          isOrgMessage == true ? 'Org' : 'Personal',
          style: kOrgLocationTextStyle,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('3:23 PM'),
            // IconButton(
            //   icon: Icon(
            //     Icons.favorite_border,
            //     color: Colors.lightBlueAccent,
            //   ),
            //   onPressed: () {
            //     print('something');
            //   },
            // ),
          ],
        ),
        onTap: () {
          print('this should take me to the chat screen');
          //Navigator.pushNamed(context, RouteHelper.messageScreen);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                channelId: channelName,
                orgId: Provider.of<ChannelData>(context, listen: false).orgName,
              ),
            ),
          );
        },
      ),
    );
  }
}
