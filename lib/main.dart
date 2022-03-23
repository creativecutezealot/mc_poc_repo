import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mcpoc/provider_helpers/group_data.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/provider_helpers/org_data.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/helpers/route_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MCChat());
}

class MCChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => OrgData(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupData(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChannelData(),
        )
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            print('removing focus');
          }
        },
        child: MaterialApp(
            initialRoute: FirebaseAuth.instance.currentUser != null
                ? RouteHelper.initialRouteLoggedInUser
                : RouteHelper.initialRouteDefault,
            routes: RouteHelper.getRoutes(context)),
      ),
    );
  }
}
