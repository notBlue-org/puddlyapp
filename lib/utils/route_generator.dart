import 'package:driversapp/screens/app/crate_page.dart';
import 'package:driversapp/screens/app/home_page.dart';
import 'package:driversapp/screens/app/order_page.dart';
import 'package:driversapp/screens/app/payment.dart';
import 'package:driversapp/screens/app/store_page.dart';
import 'package:driversapp/screens/login_page.dart';
import 'package:driversapp/screens/app/payment.dart';

import 'package:driversapp/static_assets/profile_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login_page':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home_page':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/crate_page':
        return MaterialPageRoute(builder: (_) => const Cratepage());
      case '/order_page':
        return MaterialPageRoute(builder: (_) => const OrderPage());
      case '/store_page':
        return MaterialPageRoute(builder: (_) => const StorePage());
      case '/profile_page':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
