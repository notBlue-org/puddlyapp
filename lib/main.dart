import 'package:driversapp/utils/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DriversApp());
}

class DriversApp extends StatefulWidget {
  const DriversApp({Key? key}) : super(key: key);

  @override
  _DriversAppState createState() => _DriversAppState();
}

class _DriversAppState extends State<DriversApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    User? _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      Navigator.of(context).pushReplacementNamed(
        '/home_page',
      );
    } else {
      Navigator.of(context).pushReplacementNamed(
        '/login_page',
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        return const SplashScreen();
      },
    );
  }
}
