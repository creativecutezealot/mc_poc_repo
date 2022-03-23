import 'package:flutter/widgets.dart';
import 'package:mcpoc/screens/add_member_screen.dart';
import 'package:mcpoc/screens/chat_screens/channel_list_screen.dart';
import 'package:mcpoc/screens/chat_screens/channel_page.dart';
import 'package:mcpoc/screens/chat_screens/create_new_channel.dart';
import 'package:mcpoc/screens/chat_screens/group_chat_details_screen.dart';
import 'package:mcpoc/screens/chat_screens/new_chat_screen.dart';
import 'package:mcpoc/screens/chat_screens/new_group_chat_screen.dart';
import 'package:mcpoc/screens/welcome_screen.dart';
import 'package:mcpoc/screens/login/email_login_screen.dart';
import 'package:mcpoc/screens/login/phone_login_screen.dart';
import 'package:mcpoc/screens/registration_screen.dart';
import 'package:mcpoc/screens/message_screens/message_screen.dart';
import 'package:mcpoc/screens/selection_screen.dart';
import 'package:mcpoc/screens/home_screen.dart';
import 'package:mcpoc/screens/channel_screen.dart';
import 'package:mcpoc/screens/message_screens/add_topic_screen.dart';
import 'package:flutter/material.dart';

class RouteHelper {
  BuildContext context;
  static String initialRouteDefault = WelcomeScreen.id;
  static String initialRouteLoggedInUser = HomeScreen.id;
  static String messageScreen = MessageScreen.id;

  static Map<String, WidgetBuilder> authenticatedRoutes(BuildContext context) {
    return {
      SelectionScreen.id: (context) => SelectionScreen(),
      HomeScreen.id: (context) => HomeScreen(),
      ChannelScreen.id: (context) => ChannelScreen(),
      MessageScreen.id: (context) => MessageScreen(channelId: '', orgId: ''),
      AddTopicScreen.id: (context) => AddTopicScreen(),
      // CreateNewChannel.id: (context) => CreateNewChannel(),
      ChannelListScreen.id: (context) => ChannelListScreen(),
      NewChatScreen.id: (context) => NewChatScreen(chatClient: (ModalRoute.of(context)!.settings.arguments as NewChatScreenArgs).chatClient),
      NewGroupChatScreen.id: (context) => NewGroupChatScreen(chatClient: (ModalRoute.of(context)!.settings.arguments as NewGroupChatScreenArgs).chatClient),
      AddMemberScreen.id: (context) => AddMemberScreen(),
      ChannelPage.id: (context) => ChannelPage(chatClient: (ModalRoute.of(context)!.settings.arguments as ChannelPageArgs).chatClient, channel: (ModalRoute.of(context)!.settings.arguments as ChannelPageArgs).channel),
      GroupChatDetailsScreen.id: (context) => GroupChatDetailsScreen(chatClient: (ModalRoute.of(context)!.settings.arguments as GroupChatDetailsScreenArgs).chatClient, selectedUsers: (ModalRoute.of(context)!.settings.arguments as GroupChatDetailsScreenArgs).selectedUsers)
    };
  }

  static Map<String, WidgetBuilder> defaultRoutes(BuildContext context) {
    return {
      WelcomeScreen.id: (context) => WelcomeScreen(),
      EmailLoginScreen.id: (context) => EmailLoginScreen(),
      PhoneLoginScreen.id: (context) => PhoneLoginScreen(),
      RegistrationScreen.id: (context) => RegistrationScreen(),
    };
  }

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      ...RouteHelper.defaultRoutes(context),
      ...RouteHelper.authenticatedRoutes(context)
    };
  }

  // static Route<dynamic>? generateRoute(RouteSettings settings) {
  //   final args = settings.arguments;
  //   print(settings);
  //   print(settings.name);
  //   switch (settings.name) {
  //     case WelcomeScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: WelcomeScreen.id),
  //           builder: (_) {
  //             return WelcomeScreen();
  //           });
  //     case SelectionScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: SelectionScreen.id),
  //           builder: (_) {
  //             return SelectionScreen();
  //           });
  //     case HomeScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: HomeScreen.id),
  //           builder: (_) {
  //             return HomeScreen();
  //           });
  //     case ChannelScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: ChannelScreen.id),
  //           builder: (_) {
  //             return ChannelScreen();
  //           });
  //     case MessageScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: MessageScreen.id),
  //           builder: (_) {
  //             return MessageScreen(channelId: '', orgId: '');
  //           });
  //     case AddTopicScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: AddTopicScreen.id),
  //           builder: (_) {
  //             return AddTopicScreen();
  //           });
  //     case NewChatScreen.id:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: NewChatScreen.id),
  //           builder: (_) {
  //             return NewChatScreen();
  //           });
  //     // case Routes.NEW_GROUP_CHAT:
  //     //   return MaterialPageRoute(
  //     //       settings: const RouteSettings(name: Routes.NEW_GROUP_CHAT),
  //     //       builder: (_) {
  //     //         return NewGroupChatScreen();
  //     //       });
  //     // case Routes.NEW_GROUP_CHAT_DETAILS:
  //     //   return MaterialPageRoute(
  //     //       settings: const RouteSettings(name: Routes.NEW_GROUP_CHAT_DETAILS),
  //     //       builder: (_) {
  //     //         return GroupChatDetailsScreen(
  //     //           selectedUsers: args as List<User>?,
  //     //         );
  //     //       });
  //     // case Routes.CHAT_INFO_SCREEN:
  //     //   return MaterialPageRoute(
  //     //       settings: const RouteSettings(name: Routes.CHAT_INFO_SCREEN),
  //     //       builder: (context) {
  //     //         return ChatInfoScreen(
  //     //           user: args as User?,
  //     //           messageTheme: StreamChatTheme.of(context).ownMessageTheme,
  //     //         );
  //     //       });
  //     // case Routes.GROUP_INFO_SCREEN:
  //     //   return MaterialPageRoute(
  //     //       settings: const RouteSettings(name: Routes.GROUP_INFO_SCREEN),
  //     //       builder: (context) {
  //     //         return GroupInfoScreen(
  //     //           messageTheme: StreamChatTheme.of(context).ownMessageTheme,
  //     //         );
  //     //       });
  //     // case Routes.CHANNEL_LIST_PAGE:
  //     //   return MaterialPageRoute(
  //     //       settings: const RouteSettings(name: Routes.CHANNEL_LIST_PAGE),
  //     //       builder: (context) {
  //     //         return ChannelListPage();
  //     //       });
  //     // Default case, should not reach here.
  //     default:
  //       return MaterialPageRoute(
  //           settings: const RouteSettings(name: HomeScreen.id),
  //           builder: (_) {
  //             return HomeScreen();
  //       });
  //   }
  // }


  RouteHelper(this.context) {}
}
