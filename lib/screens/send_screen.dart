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
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Messages'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: FetchData.getUsers(),
          builder: (context, snapshot) {
            List<Users> users = snapshot.data;
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return buildCard(user);
                  },
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

  Widget buildCard(Users user) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        leading: CircleAvatar(child: Text(user.id.toString())),
        title: Text(user.name),
        subtitle: Text('${user.post}, ${user.mobile}'),
        trailing: Checkbox(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
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
