
import 'package:animate_do/animate_do.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter/material.dart';
import 'dart:async';



class VerificationPage extends StatefulWidget {
  const VerificationPage({ Key? key }) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer =  Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;

        if (_currentIndex == 3)
          _currentIndex = 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    child: Image(
                      image: AssetImage('assets/images/email.png'),
                    )
                  ),
                  SizedBox(height: 30,),
                  FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: Text("Verification", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 30,),
                  FadeInDown(
                    delay: Duration(milliseconds: 500),
                    duration: Duration(milliseconds: 500),
                    child: Text("Please enter the 4 digit code sent",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500, height: 1.5),),
                  ),
                  SizedBox(height: 30,),

                  // Verification Code Input
                  FadeInDown(
                    delay: Duration(milliseconds: 600),
                    duration: Duration(milliseconds: 500),
                    child: VerificationCode(
                      length: 4,
                      textStyle: TextStyle(fontSize: 20, color: Colors.black),
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


                  SizedBox(height: 20,),
                  FadeInDown(
                    delay: Duration(milliseconds: 700),
                    duration: Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Did not recieve  OTP?", style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
                        TextButton(
                            onPressed: () {
                              if (_isResendAgain) return;
                              resend();
                            },
                            child: Text(_isResendAgain ? "Try again in " + _start.toString() : "Resend", style: TextStyle(color: Colors.orangeAccent),)
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  FadeInDown(
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 500),
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: _code.length < 4 ? () => {} : () { verify(); },
                      color: Colors.lightBlue.shade400,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: _isLoading ? Container(
                        width: 20,
                        height: 20,
                        child: const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                          color: Colors.black,
                        ),
                      ) : _isVerified ? Icon(Icons.check_circle, color: Colors.white, size: 30,) : Text("Verify", style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],)
          ),
        )
    );
  }
}