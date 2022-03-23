import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/org_data.dart';
import 'package:mcpoc/widgets/org_tile.dart';
import 'package:provider/provider.dart';

class ActiveOrgList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrgData>(
      builder: (context, orgData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final org = orgData.activeOrgs[index];
            print('active_org_list ${org.orgID}');
            return OrgTile(
              orgID: org.orgID,
              orgName: org.orgName,
              orgLocation: org.orgLocation,
              unreadMessages: org.unreadMessages,
              trailingWidgetCallback: (activeStatus) {
                // Callback that takes us to the next screen
                //orgData.updateSelection(org);
              },

//              removeItemCallback: () {
//                taskData.removeTask(org);
//              },
            );
          },
          //Item count is a property to tell the builder how many items are in a dynamic list view - necessary for dynamic lists to prevent stack overflow
          itemCount: orgData.getActiveOrgCount,
        );
      },
    );
  }
}
