import 'package:driversapp/models/user.dart';
import 'package:driversapp/utils/login.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: const Center(child: ProfileBody()));
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: Misc.getUser(),
      builder: (
        BuildContext context,
        AsyncSnapshot<AppUser> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name: ${snapshot.data!.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    'User Class: ${snapshot.data!.type}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    'Email: ${snapshot.data!.user.email}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  snapshot.data!.user.emailVerified
                      ? Text(
                          'Email verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.green),
                        )
                      : Text(
                          'Email not verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.red),
                        ),
                  VerificationBody(snapshot.data!.user),
                  ElevatedButton(
                      onPressed: () async {
                        FireAuth.signOut(context);
                      },
                      child: const Text('Sign out'))
                ]);
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}

class VerificationBody extends StatefulWidget {
  final User _currentUser;
  const VerificationBody(this._currentUser, {Key? key}) : super(key: key);

  @override
  _VerificationBodyState createState() => _VerificationBodyState(_currentUser);
}

class _VerificationBodyState extends State<VerificationBody> {
  bool _isSendingVerification = false;
  User _currentUser;

  _VerificationBodyState(this._currentUser);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        _isSendingVerification
            ? const CircularProgressIndicator()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSendingVerification = true;
                      });
                      await _currentUser.sendEmailVerification();
                      setState(() {
                        _isSendingVerification = false;
                      });
                    },
                    child: const Text('Verify email'),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      User? user = await FireAuth.refreshUser(_currentUser);
                      if (user != null) {
                        setState(() {
                          _currentUser = user;
                        });
                      }
                    },
                  ),
                ],
              ),
      ],
    );
  }
}
