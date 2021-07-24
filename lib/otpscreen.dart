import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_youtube/mainscreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  OtpScreen({required String this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String smsOtp = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId = "";

  Future signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: smsOtp);
      final UserCredential userdata =
          await _auth.signInWithCredential(credential);
      final User? currentUser = await _auth.currentUser;
      assert(userdata.user!.uid == currentUser!.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Otp Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PinCodeTextField(
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 50,
            activeFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              onCompleted: (v) {
            print("Completed");
              },
              onChanged: (value) {
            print(value);
            setState(() {
              smsOtp = value;
            });
              },
              beforeTextPaste: (text) {
            print("Allowing to paste $text");
            return true;
              },
              appContext: context,
            ),
            TextButton(
                onPressed: () {
                  signIn();
                },
                child: Text('Get Started'))
          ],
        ),
      ),
    );
  }
}
