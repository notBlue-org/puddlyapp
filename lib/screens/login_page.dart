import 'package:driversapp/utils/login.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../static_assets/wave_svg.dart';
import '../static_assets/bottom_wave.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GlobalKey<State> _keyLoader = GlobalKey<State>();
final _loginId = TextEditingController();
final _passwordId = TextEditingController();
final _formKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          body: Stack(alignment: Alignment.center, children: [
            Positioned(
              top: -10,
              child: WaveSvg(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 6 + 100,
              child: const Login(),
            ),
            Positioned(
              bottom: -310,
              child: BottomWave(),
            )
          ]),
        ));
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _usernameField(),
            _passwordField(),
            const LoginButton(),
          ],
        ));
  }
}

Widget _usernameField() {
  return SizedBox(
    width: 300,
    child: Card(
      color: Colors.white70,
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'Email ID',
        ),
        controller: _loginId,
      ),
    ),
  );
}

Widget _passwordField() {
  return SizedBox(
    width: 300,
    child: Card(
      color: Colors.white70,
      child: TextFormField(
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
        controller: _passwordId,
      ),
    ),
  );
}

class LoginButton extends StatefulWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  void _loginUser(BuildContext context) async {
    String email = _loginId.text.trim();
    String password = _passwordId.text.trim();

    FocusScope.of(context).unfocus();
    String? _validationResult = Validator.validate(
        email: _loginId.text.trim(), password: _passwordId.text.trim());
    if (_validationResult != null) {
      Misc.createSnackbar(context, _validationResult);
      return;
    } else {
      Misc.showLoadingDialog(context, _keyLoader);
      User? _currentUser = await FireAuth.signInUsingEmailPassword(
          context: context, email: email, password: password);
      Navigator.of(context, rootNavigator: true).pop();

      try {
        if (_currentUser != null) {
          Navigator.of(context).pushReplacementNamed(
            '/home_page',
          );
        }
      } catch (e) {
        Misc.createSnackbar(context, 'Error: $e.code');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      width: 280,
      child: ElevatedButton(
        child: const Text('Login'),
        onPressed: () {
          _loginUser(context);
        },
        style: ElevatedButton.styleFrom(
          primary: const Color(0xff23233c),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
