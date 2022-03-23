import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:provider/provider.dart';

class AddTopicScreen extends StatelessWidget {
  static const String id = 'add_topic_screen';
  String? newTopicName;
  String? newTopicType;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        title: Text('Add Member'),
      ),
      body: Container(
        color: Color(0xFF757575),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Topic',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Topic: ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter the new topic',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a topic';
                                }
                                return null;
                              },
                              onChanged: (newText) {
                                newTopicName = newText;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'People: ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter participants',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter participants';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            newTopicType = 'Group';
                            // Validate will return true if the form is valid, or false if invalid
                            Provider.of<ChannelData>(context, listen: false)
                                .addChannel(newTopicName!, 0, DateTime.now());
                            // Provider.of<TaskData>(context, listen: false)
                            //     .addTask(newTaskDescription);
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
