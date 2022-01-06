import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:sahayak/screens/login_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String username;
  VerifyScreen({required this.username});


  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late int time;
  final _firestore = FirebaseFirestore.instance;
  
  Future<void> checkEmailVerification() async {
    user = _auth.currentUser!;
    await user.reload();

    print(user.emailVerified);
    if (user.emailVerified) {
      timer.cancel();
      _firestore.collection('userDetails').doc(user.email).set({'email':user.email,'username':widget.username,'uid':user.uid,'login':false,});
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
    print(time);
    if (time == 60) {
      time = 0;
      user.delete();
      print('user has been deleted');
      timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    user = _auth.currentUser!;
    user.sendEmailVerification();
    Fluttertoast.showToast(
        msg:
            'Verification mail has been sent to the mail. Click to verify Your mail. The link is valid for 10 minutes only .');
    time = 0;
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      time += 2;
      checkEmailVerification();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Mail has been sent to your email',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
