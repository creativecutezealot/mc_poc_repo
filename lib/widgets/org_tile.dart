import 'package:flutter/material.dart';
import 'package:mcpoc/constants.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/screens/channel_screen.dart';
import 'package:provider/provider.dart';

class OrgTile extends StatelessWidget {
  OrgTile(
      {this.isSetupTile = false,
      required this.orgID,
      required this.orgName,
      required this.orgLocation,
      this.isChecked = false,
      required this.unreadMessages,
      required this.trailingWidgetCallback});

  final bool isSetupTile;
  final String orgID;
  final String orgName;
  final String orgLocation;
  final bool isChecked;
  final int unreadMessages;
  final void Function(bool?)? trailingWidgetCallback;

  Widget getTrailingWidget() {
    if (isSetupTile) {
      return Checkbox(
        value: isChecked,
        onChanged: trailingWidgetCallback,
      );
    } else {
      return Icon(Icons.navigate_next, color: kTileIconColor);
    }
  }

  Widget getLeadingWidget() {
    if (isSetupTile) {
      return IconButton(
        icon: Icon(
          Icons.info_outline,
          color: kTileIconColor,
        ),
        onPressed: () {
          //TODO: Handle info button press
          print('info button pressed on ListTile');
        },
      );
    } else {
      return Text(
        unreadMessages != null ? '$unreadMessages' : '0',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kTileIconColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getLeadingWidget(),
      title: Text(
        orgName,
        style: kOrgNameTextStyle,
      ),
      subtitle: Text(
        orgLocation,
        style: kOrgLocationTextStyle,
      ),
      trailing: getTrailingWidget(),
      onTap: () {
        //TODO Pick up from here to get chat screen
        if (isSetupTile == false) {
          Provider.of<ChannelData>(context, listen: false).orgName = orgName;
          Provider.of<ChannelData>(context, listen: false).orgID = orgID;
          Navigator.pushNamed(context, ChannelScreen.id);
          print('entering the channel screen');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrgMessageScreen(
          //       orgName: orgName,
          //     ),
          //   ),
          // );
        }
      },
    );
  }
}
