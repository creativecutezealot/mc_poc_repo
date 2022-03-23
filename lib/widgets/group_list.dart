import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/group_data.dart';
import 'package:mcpoc/widgets/group_tile.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ActiveGroupList extends StatelessWidget {
  void Function(List<String>)? widgetCallback;
  List<String> values = [];

  ActiveGroupList({
    this.widgetCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupData>(
      builder: (context, groupData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final group = groupData.activeGroups[index];
            return GroupTile(
              groupName: group.groupName,
              leadingWidgetCallback: (activeStatus) {
                // Callback that takes us to the next screen
                //orgData.updateSelection(org);
                print('group_list');
                print(activeStatus);
                print(group.groupName);
                if (activeStatus == true) {
                  values.add(group.groupName);
                } else {
                  values.removeWhere((element) => element == group.groupName);
                }
                print(values);
                widgetCallback!(values);
              },

//              removeItemCallback: () {
//                taskData.removeTask(org);
//              },
            );
          },
          //Item count is a property to tell the builder how many items are in a dynamic list view - necessary for dynamic lists to prevent stack overflow
          itemCount: groupData.getActiveGroupCount,
        );
      },
    );
  }
}
