import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mcpoc/provider_helpers/channel_data.dart';
import 'package:mcpoc/widgets/group_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AddMemberScreen extends StatefulWidget {
  static const String id = 'add_member_screen';
  @override
  _AddMemberScreen createState() => _AddMemberScreen();
}

class _AddMemberScreen extends State<AddMemberScreen> {
  void itemChange(bool? val, int index) {
    if (val != null) {
      setState(() {});
    }
  }

  String? _phone;
  String? _displayName;
  List<String>? _groups;
  bool showSpinner = false;

  void showAlert(String? title, String? content, String? ok, String? cancel) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title as String),
              content: Text(content as String),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, cancel as String),
                  child: Text(cancel as String),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, ok as String),
                  child: Text(ok as String),
                ),
              ],
            ));
  }

  void handleAddMember() async {
    try {
      print('phone: ');
      print(_phone);
      print('displayName: ');
      print(_displayName);
      print(_groups);
      print(Provider.of<ChannelData>(context, listen: false).orgName);
      if (_phone == null) {
        setState(() {
          showSpinner = false;
        });
        showAlert('Error', 'Phone number is required!', 'OK', 'Cancel');
        return;
      }
      if (_displayName == null) {
        setState(() {
          showSpinner = false;
        });
        showAlert('Error', 'Display name is required!', 'OK', 'Cancel');
        return;
      }
      if (_groups == null || _groups!.length == 0) {
        setState(() {
          showSpinner = false;
        });
        showAlert('Error', 'Group is required!', 'OK', 'Cancel');
        return;
      }

      String group_params = '&groups[]=' + _groups!.join('&groups[]=');

      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'addMember?phoneNumber=' +
              Uri.encodeComponent(_phone as String) +
              '&orgId=' +
              Uri.encodeComponent(
                  Provider.of<ChannelData>(context, listen: false).orgName) +
              '&displayName=' +
              Uri.encodeComponent(_displayName as String) +
              group_params);
      dynamic resp = await callable.call();
      print('add member: ');
      print(group_params);
      print(resp.data['data']);
      print(resp.data['status']);
      if (resp.data['status'] == true) {
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
      } else {
        String errorMessage = resp.data['data'];
        showAlert('Error', errorMessage, 'OK', 'Cancel');
      }
    } catch (e) {
      print("Error while calling function.");
      showAlert('Error', 'Error while calling function.', 'OK', 'Cancel');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            //TODO: Change HomeScreen menu action from 'back' to context menu
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text('Add Member'),
      ),
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(children: [
                                Container(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Phone Number',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'XXX-XXX-XXXX',
                                    ),
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Please enter a number';
                                    //   }
                                    //   return null;
                                    // },
                                    onChanged: (value) {
                                      _phone = '+1' + value;
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(children: [
                                Container(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Display Name',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                Container(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter display name',
                                    ),
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Please enter participants';
                                    //   }
                                    //   return null;
                                    // },
                                    onChanged: (value) {
                                      _displayName = value;
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                            child: Column(children: [
                              Container(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Select all groups that apply to member',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                              Container(
                                padding: const EdgeInsets.only(top: 12.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12)),
                                constraints: BoxConstraints(
                                    minHeight: 100, maxHeight: 350),
                                child:
                                    ActiveGroupList(widgetCallback: (values) {
                                  _groups = values;
                                }),
                              ),
                            ]),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showSpinner = true;
                              });
                              handleAddMember();
                            },
                            child: Text('Add New Member'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
