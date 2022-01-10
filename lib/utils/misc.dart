import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Validator {
  static String? validate(Set<String> set,
      {required String email, required String password}) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }
    return null;
  }
}

class Misc {
  static void createSnackbar(BuildContext context, String text) {
    var snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<AppUser> getUser() async {
    final User? _currentUser = FirebaseAuth.instance.currentUser;
    String _name = '';
    String _type = '';
    await FirebaseFirestore.instance
        .collection('Drivers')
        .where("Email", isEqualTo: _currentUser!.email)
        .get()
        .then((QuerySnapshot data) {
      Map userDetails = data.docs.elementAt(0).data() as Map;

      _name = userDetails["Name"];
      _type = userDetails["Type"];
    });
    return AppUser(_currentUser, _name, _type);
  }
}
