import 'package:auto_size_text/auto_size_text.dart';
import 'package:call_number/call_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sample_contacts/models/users.dart';
import 'package:sample_contacts/provider/dynamic_theme.dart';
import 'package:sample_contacts/screens/about_screen.dart';
import 'package:sample_contacts/screens/send_screen.dart';
import 'package:sample_contacts/services/fetch_data.dart';

class HomeScreens extends StatefulWidget {
  static const String route = '/';

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _value = true;

  @override
  void initState() {
    super.initState();
    FetchData.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
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
        elevation: 2.0,
        child: ListTile(
          title: AutoSizeText(user.name, maxLines: 1),
          subtitle: AutoSizeText('${user.post}' + ', ' + '${user.mobile}',
              maxLines: 1),
          trailing: IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: user.mobile));
              final snackbar = SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Copied to the clipboard'),
              );
              _scaffoldKey.currentState.showSnackBar(snackbar);
            },
          ),
          onTap: () => makeCall(user),
        ),
      );

  Widget themeChanger(DynamicTheme themeProvider, bool value) => IconButton(
        icon: _value ? Icon(Icons.lightbulb_outline) : Icon(Icons.wb_sunny),
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
            child: Text('SMS'),
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
}
