import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sample_contacts/models/users.dart';

class FetchData {
  static Future<List<Users>> getUsers() async {
    final response = await rootBundle.loadString('assets/users.json');
    if (response.isNotEmpty) {
      List users = json.decode(response.toString());
      return users.map((user) => Users.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
