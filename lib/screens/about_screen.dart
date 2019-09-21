import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  static const String route = 'about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('About Company'),
      ),
    );
  }
}
