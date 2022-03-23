import 'package:mcpoc/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcpoc/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key, required this.channelId, required this.orgId}) : super(key: key);
  final String channelId;
  final String orgId;
  static const String id = 'org_message_screen';
  @override
  _MessageScreen createState() => _MessageScreen();
}

class _MessageScreen extends State<MessageScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  void getCurrentUser() async {
    _auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          loggedInUser = user;
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    //getChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    //String topicName = Provider.of<TopicData>(context, listen: false).orgName;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //TODO: Add user(s) to group or individual conversations
            },
          ),
        ],
        title: Text(widget.channelId),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Class to handle and display the message stream
            MessagesStream(
              orgId: widget.orgId,
              channelId: widget.channelId,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //messageText & loggedInUser.email
                      //GCP database collection: messages; field 1: sender; field2: text
                      messageTextController.clear();
                      //sender, text, timestamp
                      //message, time_stamp, user_id, user_name
                      // _firestore
                      //     .collection('trusted_orgs')
                      //     .doc(orgId)
                      //     .collection('channels')
                      //     .doc(channelId)
                      //     .collection('messages')
                      //     .orderBy('time_stamp')
                      //     .snapshots(),
                      _firestore.collection('trusted_orgs')
                        ..doc(widget.orgId)
                            .collection('channels')
                            .doc(widget.channelId)
                            .collection('messages')
                            .add({
                          'message': messageText,
                          'user_id': loggedInUser!.phoneNumber,
                          'user_name': 'FixThisLater',
                          'time_stamp': DateTime.now(),
                        });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//     .firestore()
//     .collection("trusted_orgs")
// .doc(orgId)
// .collection("channels")
// .doc(channelId)
// .collection("messages")
// .get();

class MessagesStream extends StatelessWidget {
  MessagesStream({required this.orgId, required this.channelId});

  final String orgId;
  final String channelId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('trusted_orgs')
            .doc(orgId)
            .collection('channels')
            .doc(channelId)
            .collection('messages')
            .orderBy('time_stamp')
            .snapshots(),
        //_firestore.collection('messages').orderBy('timestamp').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong getting the message stream');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          if (snapshot.hasData) {
            //final messages = snapshot.data.documents.reversed;
            print('snapshot has data: ${snapshot.data!.docs.length}');
            //sender, text, timestamp
            //message, time_stamp, user_id, user_name
            final messages = snapshot.data!.docs.reversed;
            print(messages.length);
            List<MessageBubble> messageBubble = [];
            for (var message in messages) {
              print((message.data() as Map)['message']);
              final messageText = (message.data() as Map)['message'];
              final messageSenderName = (message.data() as Map)['user_name'];
              final messageSenderId = (message.data() as Map)['user_id'];
              final currentUser = loggedInUser!.phoneNumber;
              print(
                  'Sender = $messageSenderId and current user = $currentUser');
              final messageWidget = MessageBubble(
                sender: messageSenderName,
                message: messageText,
                isMe: messageSenderId == currentUser,
              );

              messageBubble.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                children: messageBubble,
              ),
            );
          } else {
            return Text('Unable to retrieve messages');
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender, required this.message, required this.isMe});
  final String sender;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              topLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
              bottomRight: Radius.circular(30.0),
              topRight: isMe ? Radius.circular(0.0) : Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
