import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:sample_contacts/models/users.dart';
import 'package:sample_contacts/services/fetch_data.dart';

class SendScreen extends StatefulWidget {
  static const String route = 'detail';

  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Users user;
  bool _value = false;
  List<Users> users;
  List<bool> _listCheck = List<bool>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Send Messages'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => sendSms(),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: FetchData.getUsers(),
          builder: (context, snapshot) {
            users = snapshot.data;
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text('Select all'),
                      value: _value,
                      onChanged: (bool value) {
                        setState(() {
                          for (var i = 0; i < _listCheck.length; i++) {
                            _listCheck[i] = value;
                          }
                          _value = value;
                        });
                      },
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        for (var i = 0; i < users.length; i++) {
                          if (_listCheck.length < users.length) {
                            _listCheck.add(false);
                          }
                        }
                        return buildCheckbox(user, index);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildCheckbox(Users user, int index) {
    return CheckboxListTile(
      title: Text(user.name),
      subtitle: Text('${user.mobile}'),
      value: _listCheck[index],
      onChanged: (bool value) {
        setState(() {
          _listCheck[index] = value;
        });
      },
    );
  }

  sendSms() async {
    List<String> listPhoneNumber = List<String>();
    for (var i = 0; i < _listCheck.length; i++) {
      if (_listCheck[i] == true) {
        listPhoneNumber.add(users[i].mobile);
      }
    }
    if (listPhoneNumber.length > 0) {
      await FlutterSms.sendSMS(message: null, recipients: listPhoneNumber);
    } else {
      final snackbar = SnackBar(
        content: ListTile(
          leading: Icon(
            Icons.info_outline,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('Please select any contact'),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}
