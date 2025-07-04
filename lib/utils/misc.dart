import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driversapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Validator {
  static String? validate({required String email, required String password}) {
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

  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait..Logging In",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }

  static String getCurrentDate() {
    DateTime now = DateTime.now();
    String day = now.day.toString().length == 2
        ? now.day.toString()
        : '0' + now.day.toString();
    String month = now.month.toString().length == 2
        ? now.month.toString()
        : '0' + now.month.toString();
    String orderDate = 'Orders_' +
        day +
        "-" +
        month +
        "-" +
        now.year.toString().substring(2, 4);
    return orderDate;
  }

  static List getFiveDaysDate() {
    DateFormat formatter = DateFormat('dd-MM-yy');
    var fiveDaysDate = [];
    for (int i = 0; i < 5; i++) {
      DateTime nowFiveDaysAgo = DateTime.now().add(Duration(days: -i));
      String formatted = formatter.format(nowFiveDaysAgo);
      fiveDaysDate.add("Orders_$formatted");
    }
    return fiveDaysDate;
  }
}
