import 'package:animate_do/animate_do.dart';
import 'package:driversapp/screens/payment.dart';
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
  String type_1='Verify';
  late Timer _timer;



  verify() {
    if(_code=='2561'){
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => payment()),
    );


    _timer =  Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;

      });
    });}
    else{
      setState(() {
        type_1='Wrong OTP';
        _isLoading = false;
        _isVerified = false;
      });
    }
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
                      ) : _isVerified ? Icon(Icons.check_circle, color: Colors.white, size: 30,) : Text("$type_1", style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],)
          ),
        )
    );
  }
}