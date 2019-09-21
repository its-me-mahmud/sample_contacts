import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_contacts/screens/about_screen.dart';
import 'package:sample_contacts/screens/home_screen.dart';
import 'package:sample_contacts/screens/send_screen.dart';
import 'package:sample_contacts/theme.dart';

void main() => runApp(ChangeNotifierProvider(
    builder: (context) => DynamicTheme(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);

    return MaterialApp(
      title: 'Sample Contacts',
      theme: themeProvider.getDarkMode() ? ThemeData.dark() : ThemeData.light(),
      initialRoute: HomeScreens.route,
      routes: {
        HomeScreens.route: (context) => HomeScreens(),
        SendScreen.route: (context) => SendScreen(),
        AboutScreen.route: (context) => AboutScreen(),
      },
    );
  }
}
