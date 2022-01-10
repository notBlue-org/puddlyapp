import 'package:driversapp/utils/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('data'),
            ElevatedButton(
                onPressed: () async {
                  FireAuth.signOut(context);
                },
                child: const Text('Sign out'))
          ],
        ),
      ),
    );
  }
}
