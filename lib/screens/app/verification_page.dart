import 'package:animate_do/animate_do.dart';
import 'package:driversapp/constants/colors.dart';
import 'package:driversapp/screens/app/crate_page.dart';
import 'package:driversapp/utils/misc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VerificationPage extends StatefulWidget {
  final List otplist;
  final List orderList;
  final String amountDue;
  const VerificationPage(this.otplist, this.orderList, this.amountDue,
      {Key? key})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isResendAgain = false;
  final bool _isVerified = false;
  bool _isLoading = false;
  String _code = '';

  final int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;

        if (_currentIndex == 3) _currentIndex = 0;
      });
    });

    super.initState();
  }

  verify() {
    setState(() {
      void showSnackBarAsBottomSheet(BuildContext context, String message) {
        showModalBottomSheet<void>(
          context: context,
          barrierColor: const Color.fromRGBO(0, 0, 0, 0),
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 5), () {
              try {
                Navigator.pop(context);
              } on Exception catch (e) {
                Misc.createSnackbar(context, e.toString());
              }
            });
            return Container(
                color: Colors.grey.shade800,
                padding: const EdgeInsets.all(12),
                child: Wrap(children: [
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  )
                ]));
          },
        );
      }

      List<dynamic> newList = widget.otplist;
      List orderList = widget.orderList;
      String amountDue = widget.amountDue;

      _isLoading = true;
      bool found = newList.contains(_code);
      if (found) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cratepage(orderList, amountDue),
            ));
      } else {
        showSnackBarAsBottomSheet(context, "Invalid OTP");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 250,
                      child: Image(
                        image: AssetImage('assets/images/email.png'),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: const Text(
                        "Verification",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 30,
                  ),

                  FadeInDown(
                    child: Text(
                      "Please enter the 4 digit code sent",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // Verification Code Input
                  FadeInDown(
                    child: VerificationCode(
                      length: 4,
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      underlineColor: Colors.black87,
                      keyboardType: TextInputType.number,
                      underlineUnfocusedColor: Colors.black87,
                      onCompleted: (value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      onEditing: (value) {},
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  FadeInDown(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Did not recieve  OTP?",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                        TextButton(
                            onPressed: () {
                              if (_isResendAgain) return;
                              resend();
                            },
                            child: Text(
                              _isResendAgain
                                  ? "Try again in " + _start.toString()
                                  : "Resend",
                              style:
                                  const TextStyle(color: Colors.orangeAccent),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  FadeInDown(
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: _code.length < 4
                          ? () => {}
                          : () {
                              verify();
                            },
                      color: kButtonColor,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 3,
                                color: Colors.black,
                              ),
                            )
                          : _isVerified
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Text(
                                  "Verify",
                                  style: TextStyle(color: Colors.white),
                                ),
                    ),
                  )
                ],
              )),
        ));
  }
}
