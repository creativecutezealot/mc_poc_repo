import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/org_data.dart';
import 'package:mcpoc/widgets/org_tile.dart';
import 'package:provider/provider.dart';

class MasterOrgList extends StatelessWidget {
  MasterOrgList({this.isSetupTile = false});

  final bool isSetupTile;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrgData>(
      builder: (context, orgData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final org = orgData.orgs[index];
            return OrgTile(
              isSetupTile: isSetupTile,
              orgID: org.orgID,
              orgName: org.orgName,
              orgLocation: org.orgLocation,
              isChecked: org.isChecked,
              trailingWidgetCallback: (checkboxStatus) {
                orgData.updateSelection(org);
              }, unreadMessages: 0,
//              removeItemCallback: () {
//                taskData.removeTask(org);
//              },
            );
          },
          //Item count is a property to tell the builder how many items are in a dynamic list view - necessary for dynamic lists to prevent stack overflow
          itemCount: orgData.orgCount,
        );
      },
    );
  }
}
