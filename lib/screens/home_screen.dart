import 'package:call_number/call_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';
import 'package:sample_contacts/models/users.dart';
import 'package:sample_contacts/screens/about_screen.dart';
import 'package:sample_contacts/screens/send_screen.dart';
import 'package:sample_contacts/services/fetch_data.dart';
import 'package:sample_contacts/theme.dart';

class HomeScreens extends StatefulWidget {
  static const String route = '/';

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  bool _value = true;

  @override
  void initState() {
    super.initState();
    FetchData.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          themeChanger(themeProvider, _value),
          buildPopupMenu(),
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

  Widget buildCard(Users user) => Card(
        elevation: 4.0,
        child: ListTile(
          leading: CircleAvatar(child: Text(user.id.toString())),
          title: Text(user.name),
          subtitle: Text('${user.post}, ${user.mobile}'),
          trailing: IconButton(
              icon: Icon(Icons.message), onPressed: () => sendSms(user)),
          onTap: () => makeCall(user),
        ),
      );

  Widget themeChanger(DynamicTheme themeProvider, bool value) => IconButton(
        icon: _value ? Icon(Icons.brightness_low) : Icon(Icons.brightness_high),
        onPressed: () {
          setState(() {
            _value = !_value;
            themeProvider.changeDarkMode(value);
          });
        },
      );

  Widget buildPopupMenu() => PopupMenuButton(
        offset: Offset(0, 46),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'sms',
            child: Text('Send messages'),
          ),
          PopupMenuItem(
            value: 'about',
            child: Text('About'),
          ),
        ],
        onSelected: (select) {
          switch (select) {
            case 'sms':
              Navigator.pushNamed(context, SendScreen.route);
              break;
            case 'about':
              Navigator.pushNamed(context, AboutScreen.route);
              break;
            default:
              return null;
          }
        },
      );

  void makeCall(Users user) async {
    if (user != null) await CallNumber().callNumber(user.mobile);
  }

  void sendSms(Users user) async {
    if (user != null)
      await FlutterSms.sendSMS(
        message: null,
        recipients: <String>[user.mobile],
      );
  }
}
