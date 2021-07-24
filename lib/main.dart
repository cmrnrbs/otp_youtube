import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otp_youtube/otpscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String phoneNo = "+905305552020";
  late String smsOtp = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId = "";

  Future verifyPhone() async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exc) {
            print(exc);
          },
          codeSent: (String verId, [int? forceResendingToken]) {
            this.verificationId = verId;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(verificationId: verId)));
          },
          timeout: const Duration(seconds: 20),
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId = verificationId;
          });
    } catch (e) {
      inspect(e).hashCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: "+905305552020",
              decoration:
                  InputDecoration(hintText: "Please enter your phone number"),
            ),
            TextButton(
                onPressed: () {
                  verifyPhone();
                },
                child: Text('Verifiy'))
          ],
        ),
      ),
    );
  }
}
