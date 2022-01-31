import 'package:driversapp/screens/crate_page.dart';
import 'package:driversapp/screens/home_page.dart';
import 'package:driversapp/screens/login_page.dart';
import 'package:driversapp/screens/order_page.dart';
import 'package:driversapp/screens/otp_checker.dart';
import 'package:driversapp/static_assets/profile_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home_page':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/profile_page':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/login_page':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/crate_page':
        return MaterialPageRoute(builder: (_) => const CratePage());
      case '/verification_page':
        return MaterialPageRoute(builder: (_) => const VerificationPage());
      case '/order_page':
        return MaterialPageRoute(builder: (_) => const OrderPage());

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
