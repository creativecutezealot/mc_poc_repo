import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/widgets/channel_tile.dart';
import 'package:provider/provider.dart';

class ChannelList extends StatelessWidget {
  ChannelList({required this.getOrgTopic});
  final bool getOrgTopic;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelData>(
      builder: (context, topicData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            // Build two lists... one for org messages and one for personal messages
            final conversation = topicData.channels[index];
            //           if (getOrgTopic == conversation.isOrgTopic) {
            return ChannelTile(
              channelName: conversation.channelName,
              isOrgMessage: conversation.isOrgChannel,
              unreadMessages: conversation.unreadMessages,
              lastMessageTime: conversation.lastMessageTime,
              trailingWidgetCallback: (activeStatus) {
                //orgData.updateSelection(org);
              },
            );
            // } else {
            //   return null;
            // }

//TODO: CONVERSATIONS: Add new provider and class to handle and persist conversations
            return ChannelTile(
              channelName: conversation.channelName,
              isOrgMessage: conversation.isOrgChannel,
              unreadMessages: conversation.unreadMessages,
              lastMessageTime: conversation.lastMessageTime,
              trailingWidgetCallback: (activeStatus) {
                //orgData.updateSelection(org);
              },

//              removeItemCallback: () {
//                taskData.removeTask(org);
//              },
            );
          },
          //Item count is a property to tell the builder how many items are in a dynamic list view - necessary for dynamic lists to prevent stack overflow
          itemCount: topicData.channelCount,
        );
      },
    );
  }
}
