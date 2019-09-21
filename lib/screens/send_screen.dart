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
  // bool _isCheck1 = false;
  // bool _isCheck2 = false;
  // bool _isCheck3 = false;
  bool _value = false;
  List<Users> users;
  List<bool> _listCheck = new List<bool>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Messages'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              List<String> listPhoneNumber = new List<String>();
              for (var i = 0; i < _listCheck.length; i++) {
                if (_listCheck[i] == true) {
                  listPhoneNumber.add(users[i].mobile);
                }
              }
              await FlutterSms.sendSMS(
                  message: null, recipients: listPhoneNumber);
            },
          )
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
                    ListTile(
                      title: Text('Select all'),
                      trailing: Checkbox(
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
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        for (var i = 0; i < users.length; i++) {
                          if (_listCheck.length < users.length) {
                            _listCheck.add(false);
                          }
                        }
                        return buildCard(user, index);
                      },
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

  Widget buildCard(Users user, index) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        leading: CircleAvatar(child: Text(user.id.toString())),
        title: Text(user.name),
        subtitle: Text('${user.post}, ${user.mobile}'),
        trailing: Checkbox(
          value: _listCheck[index],
          onChanged: (value) {
            setState(() {
              _listCheck[index] = value;
            });
          },
        ),
      ),
    );
  }

  sendSms(Users user) async {
    if (user != null)
      await FlutterSms.sendSMS(
          message: null, recipients: <String>[user.mobile]);
  }
}
