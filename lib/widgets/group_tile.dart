import 'package:flutter/material.dart';
import 'package:mcpoc/constants.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/screens/channel_screen.dart';
import 'package:provider/provider.dart';

class GroupTile extends StatefulWidget {
  String? groupName;
  void Function(bool?)? leadingWidgetCallback;

  GroupTile(
      {Key? key,
      required this.groupName,
      required this.leadingWidgetCallback})
      : super(key: key);

  @override
  _GroupTileState createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  void Function(bool?)? leadingWidgetCallback;
  bool isChecked = false;
  Widget getLeadingWidget() {
    return Checkbox(
      value: isChecked,
      // onChanged: leadingWidgetCallback,
      onChanged: (bool? value) {
        print('value');
        print(value);
        setState(() {
          isChecked = value!;
        });
        widget.leadingWidgetCallback!(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getLeadingWidget(),
      title: Text(
        widget.groupName!,
        style: kOrgNameTextStyle,
      ),
      // trailing: getTrailingWidget(),
      onTap: () {
        //TODO Pick up from here to get chat screen
      },
    );
  }
}
