import 'package:flutter/material.dart';
import 'package:mcpoc/widgets/active_org_list.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: ActiveOrgList(),
          ),
        ),
      ],
    );
  }
}
